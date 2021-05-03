Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 352C5C43461
	for <linux-trace-devel@archiver.kernel.org>; Mon,  3 May 2021 06:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EED6611AE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  3 May 2021 06:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhECGzw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 3 May 2021 02:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhECGzw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 May 2021 02:55:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958FBC06174A
        for <linux-trace-devel@vger.kernel.org>; Sun,  2 May 2021 23:54:59 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u3so6240039eja.12
        for <linux-trace-devel@vger.kernel.org>; Sun, 02 May 2021 23:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=txq3tO8p2NeL/k7x1zS9p/wGtUdAjj1T7FTKuE2uw6k=;
        b=oEy7UW0O51JS6G7pnikCovYMVW7Gjg8KtHimEjvHRNLY3aGd4nqoLmm7Gu2VSWLpIa
         yuruBFrgoGZa6drC0BNG/wFbdSCJjsMX9KwDOM0NbtMbBUrDNtB9hJtOH1D24JZE+4Xg
         bntfY0fG1t6gAD5z8c7dzn3lMdpT1l5SBG+LucZBG4Rpg2GyZclFTC9ATh+Dl4f+bacV
         FUkO0fuHcx85k8uwiF5RJ1gXmGW/7Wtryet9AFyxMHfBusSu3OLW8gYAzT7hxXYb+XOr
         YRzwzRuFaY77D4i6500k75U39i8u3n6UKXNOONe5auXhBuS5Y+PjFWOxcw56IltiLO2f
         1aTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=txq3tO8p2NeL/k7x1zS9p/wGtUdAjj1T7FTKuE2uw6k=;
        b=AxVI7IFj2OLYGiJsvFQ70qE1o9ut7t1DrFore/jvfpnFqKsfUN/rC/TVDZ5i6LIrXz
         6hQYcpd1qJ+2t6afYuWuUwZMKCRHSQIEzBVZLyrDyouQVcc4Mj+EJtYtmyAPhOEkD/Qu
         rQfXQVcnelfs7iCWzqxOoFcriSS6+vgA9qjs1DcoDzFA7Gr6tAIpzl6klOJz3kYaOBlG
         QgiVEkP5DyI/oq1Y38OQc9oKcyxMUycV5X3AUwI47XoXYmVsowmAHzbDNPrZ/LOlYa/q
         lcvc2TmWuFDIDJ8t59DkLAltLe3zmJ9GZP3wsXWy0/NN+SMsk/B0dx7LeShVSH7dXzu9
         BsOw==
X-Gm-Message-State: AOAM532rtyMAFSXCEjb2zeqV4GVrq+4s4L4BRHTPFjyaWbWa+gZQMKC1
        7liAv/sRGdI/RPe6LfbfvNqBRi8mJtU=
X-Google-Smtp-Source: ABdhPJwGans5pcNA2PzvCMD6w6uYuMRfYCs/kVc7DfONxiq8xgJS/FMbLK7MHZSEntFL/fud4jf1Lg==
X-Received: by 2002:a17:906:6a93:: with SMTP id p19mr15532914ejr.319.1620024898175;
        Sun, 02 May 2021 23:54:58 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id qu23sm10692437ejb.1.2021.05.02.23.54.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 May 2021 23:54:57 -0700 (PDT)
Subject: Re: [RFC v2] Simple tool for VMEnters/VMExits matching and trace
 validation
To:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, dfaggioli@suse.com
References: <20210501060744.5053-1-stefano.devenuto99@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <dbbf90fb-f654-ce24-4ce2-ffedb95b25ea@gmail.com>
Date:   Mon, 3 May 2021 09:54:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210501060744.5053-1-stefano.devenuto99@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ciao Stefano,

I am on holiday this week. I will review the code next week when I am 
back to work.

Cheers,
Yordan

On 1.05.21 г. 9:07, Stefano De Venuto wrote:
> Add a tool in examples/ that scans a merged host + guest trace and
> search for host events that are inside a vmentry/vmexit block (and
> vice-versa for guest events ouside the block) and report the found
> ones.
> 
> It can be useful as a starting point for identifying issues of for
> checking the effectiveness of host/guest traces synchronization, or
> even for improving the placing of the tracepoints in the kernel.
> 
> v2 changes:
>   - Addressed Yordan's comments.
>   - Added a way to not mark as invalid the initial guests event.
>   - Used kshark_read_event_field_int() for the vCPU field recovering.
> 
> Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
> ---
>   examples/CMakeLists.txt |   4 +
>   examples/checker.c      | 224 ++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 228 insertions(+)
>   create mode 100644 examples/checker.c
> 
> diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
> index c2f4c01..91badb8 100644
> --- a/examples/CMakeLists.txt
> +++ b/examples/CMakeLists.txt
> @@ -12,6 +12,10 @@ message(STATUS "multibufferload")
>   add_executable(mbload          multibufferload.c)
>   target_link_libraries(mbload   kshark)
>   
> +message(STATUS "checker")
> +add_executable(checker          checker.c)
> +target_link_libraries(checker   kshark)
> +
>   message(STATUS "datahisto")
>   add_executable(dhisto          datahisto.c)
>   target_link_libraries(dhisto   kshark)
> diff --git a/examples/checker.c b/examples/checker.c
> new file mode 100644
> index 0000000..425de58
> --- /dev/null
> +++ b/examples/checker.c
> @@ -0,0 +1,224 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +
> +#include "libkshark.h"
> +#include "libkshark-tepdata.h"
> +
> +#define KVM_ENTRY "kvm/kvm_entry"
> +#define KVM_EXIT "kvm/kvm_exit"
> +
> +struct custom_stream
> +{
> +	struct kshark_data_stream* original_stream;
> +	int* cpus;
> +};
> +
> +/**
> + * Checks if a stream_id represents a guest.
> + * If so, @host contains the corresponding host stream_id
> + */
> +int is_guest(int stream_id,
> +	     struct kshark_host_guest_map* mapping,
> +	     int n_mapping, int* host)
> +{
> +	for (int i = 0; i < n_mapping; i++) {
> +		if (mapping[i].guest_id == stream_id) {
> +			*host = mapping[i].host_id;
> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * Recover guest stream_id from host VMentry/VMexit event.
> + * In case of success, @guest_id will contain the guest stream_id.
> + */
> +int guest_id_from_host_entry_exit(struct kshark_host_guest_map* mapping,
> +				  int n_mapping, int* guest_id,
> +				  struct kshark_entry* entry)
> +{
> +	struct kshark_data_stream* stream;
> +	int pid;
> +
> +	stream = kshark_get_stream_from_entry(entry);
> +	pid = kshark_get_pid(entry);
> +
> +	for (int i = 0; i < n_mapping; i++)
> +		if (mapping[i].host_id == stream->stream_id)
> +			for (int j = 0; j < mapping[i].vcpu_count; j++)
> +				if (mapping[i].cpu_pid[j] == pid) {
> +					*guest_id = mapping[i].guest_id;
> +					return 1;
> +				}
> +
> +	return 0;
> +}
> +
> +void print_entry(struct kshark_entry* entry)
> +{
> +	struct kshark_data_stream* stream;
> +	char* event_name;
> +
> +	stream = kshark_get_stream_from_entry(entry);
> +	event_name = kshark_get_event_name(entry);
> +
> +	printf("      %d: %s-%d, %" PRId64 " [%03d]:%s\t%s\n",
> +		stream->stream_id,
> +		kshark_get_task(entry),
> +		kshark_get_pid(entry),
> +		entry->ts,
> +		entry->cpu,
> +		event_name,
> +		kshark_get_info(entry));
> +}
> +
> +void free_data(struct kshark_context *kshark_ctx,
> +	       struct custom_stream** custom_streams,
> +	       struct kshark_entry** entries, int n_entries,
> +	       struct kshark_host_guest_map* host_guest_mapping,
> +	       int n_guest)
> +{
> +	struct custom_stream* custom_stream;
> +
> +	for (int i = 0; i < kshark_ctx->n_streams; i++) {
> +		custom_stream = custom_streams[i];
> +
> +		free(custom_stream->cpus);
> +		free(custom_stream);
> +	}
> +	free(custom_streams);
> +
> +	for (int i = 0; i < n_entries; i++)
> +		free(entries[i]);
> +	free(entries);
> +
> +	kshark_tracecmd_free_hostguest_map(host_guest_mapping, n_guest);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	struct kshark_host_guest_map* host_guest_mapping;
> +	struct custom_stream** custom_streams;
> +	struct custom_stream* custom_stream;
> +	struct custom_stream* guest_stream;
> +	struct custom_stream* host_stream;
> +	struct kshark_data_stream* stream;
> +	struct kshark_context* kshark_ctx;
> +	struct kshark_entry** entries;
> +	struct kshark_entry* current;
> +	ssize_t n_entries;
> +	char* event_name;
> +	int64_t vcpu;
> +	int guest_id;
> +	int n_guest;
> +	int host;
> +	int v_i;
> +	int sd;
> +
> +	kshark_ctx = NULL;
> +	if (!kshark_instance(&kshark_ctx))
> +		return 1;
> +
> +	custom_streams = malloc(sizeof(*custom_streams) * (argc-1));
> +
> +	for (int i = 1; i < argc; i++) {
> +		sd = kshark_open(kshark_ctx, argv[i]);
> +		if (sd < 0) {
> +			kshark_free(kshark_ctx);
> +			return 1;
> +		}
> +
> +		kshark_tep_init_all_buffers(kshark_ctx, sd);
> +
> +		/**
> +		 * Creating custom streams in order to keep track if a
> +		 * pCPU is executing code of a vCPU and, if so, which vCPU.
> +		 */
> +		custom_stream = malloc(sizeof(*custom_stream));
> +		custom_stream->original_stream = kshark_get_data_stream(kshark_ctx, sd);
> +		custom_stream->cpus = malloc(custom_stream->original_stream->n_cpus * sizeof(int));
> +		memset(custom_stream->cpus, -1, custom_stream->original_stream->n_cpus * sizeof(int));
> +
> +		custom_streams[i-1] = custom_stream;
> +	}
> +
> +	host_guest_mapping = NULL;
> +	n_guest = kshark_tracecmd_get_hostguest_mapping(&host_guest_mapping);
> +	if (n_guest < 0) {
> +		printf("Failed mapping: %d\n", n_guest);
> +		return 1;
> +	}
> +
> +	entries = NULL;
> +	n_entries = kshark_load_all_entries(kshark_ctx, &entries);
> +
> +	for (int i = 0; i < n_entries; ++i) {
> +		current = entries[i];
> +
> +		stream = kshark_get_stream_from_entry(current);
> +		event_name = kshark_get_event_name(current);
> +
> +		custom_stream = custom_streams[stream->stream_id];
> +
> +		if (!strcmp(event_name, KVM_ENTRY) || !strcmp(event_name, KVM_EXIT)) {
> +			if (kshark_read_event_field_int(current, "vcpu_id", &vcpu)) {
> +				printf("Error on recovering the vCPU field\n");
> +				return 1;
> +			}
> +
> +			if (!guest_id_from_host_entry_exit(host_guest_mapping, n_guest, &guest_id, current)) {
> +				printf("Error on recovering guest stream ID\n");
> +				return 1;
> +			}
> +
> +			/**
> +			 * Mark the vCPU upcoming events as checkable.
> +			 * Workaround implemented in order to not mark as invalid initial guests events.
> +			 * Done in this way since we can't know if we'll find a kvm_exit (consistent state)
> +			 * or a kvm_entry.
> +			 */
> +			guest_stream = custom_streams[guest_id];
> +			guest_stream->cpus[vcpu] = 1;
> +
> +			if (!strcmp(event_name, KVM_ENTRY))
> +				custom_stream->cpus[current->cpu] = vcpu;
> +			else
> +				custom_stream->cpus[current->cpu] = -1;
> +
> +		} else {
> +
> +			/**
> +			 * If the event comes from a guest, recover the pCPU where the event was executed
> +			 * and check if it's NOT OUTSIDE a kvm_entry/kvm_exit block.
> +			 */
> +			if (is_guest(stream->stream_id, host_guest_mapping, n_guest, &host)) {
> +				host_stream = custom_streams[host];
> +
> +				for (v_i = 0; v_i < host_stream->original_stream->n_cpus; v_i++) {
> +					if (current->cpu == host_stream->cpus[v_i])
> +					break;
> +				}
> +
> +				if (v_i == host_stream->original_stream->n_cpus && custom_stream->cpus[current->cpu] != -1)
> +					printf("%d G out:\t", i);
> +
> +			/**
> +			 * If the event comes from a host, recover the CPU that executed the event
> +			 * and check if it's NOT INSIDE a kvm_entry/kvm_exit block.
> +			 */
> +			} else {
> +				if (custom_stream->cpus[current->cpu] != -1)
> +					printf("%d H in:\t", i);
> +			}
> +		}
> +
> +		print_entry(entries[i]);
> +	}
> +
> +	free_data(kshark_ctx, custom_streams, entries, n_entries, host_guest_mapping, n_guest);
> +
> +	kshark_free(kshark_ctx);
> +}
> 
