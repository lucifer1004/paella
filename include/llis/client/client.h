#pragma once

#include "job_ref.h"

#include <llis/ipc/shm_channel.h>
#include <llis/ipc/unix_datagram_socket.h>
#include <llis/ipc/defs.h>

#include <cstdint>
#include <string>
#include <mutex>

namespace llis {
namespace client {

class Client {
  public:
    Client(std::string server_name);
    ~Client();

    JobRef register_job(std::string path);

    ClientId get_client_id() const {
        return client_id_;
    }

    ipc::ShmChannel* get_c2s_channel() {
        return &c2s_channel_;
    }

    ipc::ShmChannel* get_s2c_channel() {
        return &s2c_channel_;
    }

    JobInstanceRef* add_job_instance_ref(JobInstanceRef job_instance_ref);
    void release_job_instance_ref(JobInstanceRef* job_instance_ref);

    JobInstanceRef* wait();

  private:
    void generate_client_id();
    void create_s2c_channel();
    void reconnect_s2c_channel();
    void register_client();
    void connect_s2c_socket();

    std::string server_name_;

    ClientId client_id_;

    std::string s2c_socket_prefix_;

    ipc::ShmChannel c2s_channel_;
    ipc::ShmChannel s2c_channel_;
    ipc::UnixDatagramSocket s2c_socket_;

    std::vector<std::unique_ptr<JobInstanceRef>> job_instance_refs_;
    std::vector<JobInstanceRefId> unused_job_instance_refs_;

    std::mutex mtx_;
};

}
}

