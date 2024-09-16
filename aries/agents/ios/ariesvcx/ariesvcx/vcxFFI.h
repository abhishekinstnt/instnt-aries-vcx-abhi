// This file was autogenerated by some hot garbage in the `uniffi` crate.
// Trust me, you don't want to mess with it!

#pragma once

#include <stdbool.h>
#include <stdint.h>

// The following structs are used to implement the lowest level
// of the FFI, and thus useful to multiple uniffied crates.
// We ensure they are declared exactly once, with a header guard, UNIFFI_SHARED_H.
#ifdef UNIFFI_SHARED_H
    // We also try to prevent mixing versions of shared uniffi header structs.
    // If you add anything to the #else block, you must increment the version suffix in UNIFFI_SHARED_HEADER_V4
    #ifndef UNIFFI_SHARED_HEADER_V4
        #error Combining helper code from multiple versions of uniffi is not supported
    #endif // ndef UNIFFI_SHARED_HEADER_V4
#else
#define UNIFFI_SHARED_H
#define UNIFFI_SHARED_HEADER_V4
// ⚠️ Attention: If you change this #else block (ending in `#endif // def UNIFFI_SHARED_H`) you *must* ⚠️
// ⚠️ increment the version suffix in all instances of UNIFFI_SHARED_HEADER_V4 in this file.           ⚠️

typedef struct RustBuffer
{
    int32_t capacity;
    int32_t len;
    uint8_t *_Nullable data;
} RustBuffer;

typedef int32_t (*ForeignCallback)(uint64_t, int32_t, RustBuffer, RustBuffer *_Nonnull);

typedef struct ForeignBytes
{
    int32_t len;
    const uint8_t *_Nullable data;
} ForeignBytes;

// Error definitions
typedef struct RustCallStatus {
    int8_t code;
    RustBuffer errorBuf;
} RustCallStatus;

// ⚠️ Attention: If you change this #else block (ending in `#endif // def UNIFFI_SHARED_H`) you *must* ⚠️
// ⚠️ increment the version suffix in all instances of UNIFFI_SHARED_HEADER_V4 in this file.           ⚠️
#endif // def UNIFFI_SHARED_H

void ffi_vcx_743a_ProfileHolder_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void ffi_vcx_743a_Connection_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Connection_get_state(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Connection_pairwise_info(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Connection_accept_invitation(
      void*_Nonnull ptr,void*_Nonnull profile,RustBuffer invitation,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Connection_handle_request(
      void*_Nonnull ptr,void*_Nonnull profile,RustBuffer request,RustBuffer service_endpoint,RustBuffer routing_keys,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Connection_handle_response(
      void*_Nonnull ptr,void*_Nonnull profile,RustBuffer response,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Connection_send_request(
      void*_Nonnull ptr,void*_Nonnull profile,RustBuffer service_endpoint,RustBuffer routing_keys,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Connection_send_response(
      void*_Nonnull ptr,void*_Nonnull profile,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Connection_send_ack(
      void*_Nonnull ptr,void*_Nonnull profile,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Connection_send_message(
      void*_Nonnull ptr,void*_Nonnull profile,RustBuffer message,
    RustCallStatus *_Nonnull out_status
    );
void ffi_vcx_743a_Holder_object_free(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Holder_set_proposal(
      void*_Nonnull ptr,RustBuffer credential_proposal,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Holder_prepare_credential_request(
      void*_Nonnull ptr,void*_Nonnull profile,RustBuffer my_pw_did,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_msg_credential_request(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_decline_offer(
      void*_Nonnull ptr,RustBuffer comment,
    RustCallStatus *_Nonnull out_status
    );
void vcx_743a_Holder_process_credential(
      void*_Nonnull ptr,void*_Nonnull profile,RustBuffer credential,
    RustCallStatus *_Nonnull out_status
    );
int8_t vcx_743a_Holder_is_terminal_state(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_state(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_source_id(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_credential(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_attributes(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_attachment(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_offer(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_tails_location(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_tails_hash(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_rev_reg_id(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_cred_id(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_thread_id(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
int8_t vcx_743a_Holder_is_revokable(
      void*_Nonnull ptr,void*_Nonnull profile,
    RustCallStatus *_Nonnull out_status
    );
int8_t vcx_743a_Holder_is_revoked(
      void*_Nonnull ptr,void*_Nonnull profile,
    RustCallStatus *_Nonnull out_status
    );
uint32_t vcx_743a_Holder_get_cred_rev_id(
      void*_Nonnull ptr,void*_Nonnull profile,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_problem_report(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_Holder_get_final_message(
      void*_Nonnull ptr,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull vcx_743a_new_indy_profile(
      RustBuffer wallet_config,RustBuffer genesis_file_path,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull vcx_743a_create_inviter(
      void*_Nonnull profile,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull vcx_743a_create_invitee(
      void*_Nonnull profile,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_unpack_message(
      void*_Nonnull profile,RustBuffer packed_msg,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull vcx_743a_create(
      RustBuffer source_id,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull vcx_743a_create_from_offer(
      RustBuffer source_id,RustBuffer offer_message,
    RustCallStatus *_Nonnull out_status
    );
void*_Nonnull vcx_743a_create_with_proposal(
      RustBuffer source_id,RustBuffer propose_credential,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer vcx_743a_get_credentials(
      void*_Nonnull profile,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer ffi_vcx_743a_rustbuffer_alloc(
      int32_t size,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer ffi_vcx_743a_rustbuffer_from_bytes(
      ForeignBytes bytes,
    RustCallStatus *_Nonnull out_status
    );
void ffi_vcx_743a_rustbuffer_free(
      RustBuffer buf,
    RustCallStatus *_Nonnull out_status
    );
RustBuffer ffi_vcx_743a_rustbuffer_reserve(
      RustBuffer buf,int32_t additional,
    RustCallStatus *_Nonnull out_status
    );