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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2668C433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Apr 2021 08:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE6E611C9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Apr 2021 08:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhDTINe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 04:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhDTINe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 04:13:34 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FD8C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Apr 2021 01:13:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k26so20198955wrc.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Apr 2021 01:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VMVmrsfRquux93knTfKLX2x3B/FEeHX950tH1EMcDgw=;
        b=M/NJSlx8wLJA3hMyb6aNtXtTp38u/a0o03XA74EXg9ZFJp/5BS4ojNH5eKqadtThFB
         c6hiZTBDliQf8P5t7L/rqBahsZx/0fv1CIvOJ7tKSVrj+dwtrIKM0rUbGl9Zei2Q/VQQ
         wcSXKcnBXgGAfWFCAQna6BNuPzaDstYxwnMpsFhNq/mijVH+fdwnudNNganStSpcFA+z
         R9pGS2/j81eAdyksVDzRF/oGGkb7oESTPHWGduVMi+57vMKP/8ioSKdqQxRcseWof7s+
         R5Ioe9kQuw2G1VWyL51tZDekqMYpl2cUnfooYVkA6lsVF3D/zl9qkzMmBjFQ6XyfU0ss
         amLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VMVmrsfRquux93knTfKLX2x3B/FEeHX950tH1EMcDgw=;
        b=jsEspheee43ZwzBpmU9NUWTNLhgOZ4GQnwlNoTSSdV1glY3udIR8ShQz258pq1eE0L
         nG9qawGom/67RDTUJT8xhwErUfXiQ4dbbMWfCe3I1EP4IuqEHI1/7z/Z12F95feeeBhq
         8lXwCGO+qdFfMc8p96PwzMcPQTG9Wf/tz8d3Hhtqta70XxRhvBDdAeKy7r9eld9yDqbT
         4vi4wsrCXENOwdNqDqwOdfoSBy19oxNxmA7lXeQihGFGdOMS4kQQ+5yI4pJsPsGUp3SX
         pf77RARMQ/EmJ1QWU11FlajAq168PyjrJ8JgtYik8d/wbe4O783ncqF9tYsOYAUEfcKT
         Et+A==
X-Gm-Message-State: AOAM531HrQzpZfTWVJGKBiAtTsgiWPd7BwAe1v62xrxG8YkmSLBu1g5w
        PUAvgPkuyqoV/oSlJDsyXv8=
X-Google-Smtp-Source: ABdhPJyY8uPMN/7hDZcumTQJgvsWzgTJl+apSP8B+j9jBG1vwGjg7AYMmjO53z2InYpVwrDsH0KOGA==
X-Received: by 2002:adf:fe12:: with SMTP id n18mr18978307wrr.17.1618906381708;
        Tue, 20 Apr 2021 01:13:01 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id i12sm24958362wrm.77.2021.04.20.01.13.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 01:13:01 -0700 (PDT)
Subject: Re: [RFC] Simple tool for VMEnters/VMExits matching and trace
 validation
To:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, dfaggioli@suse.com
References: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <7edad92d-3297-fd42-9ac2-0334816fb524@gmail.com>
Date:   Tue, 20 Apr 2021 11:12:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ciao Stefano,

First of all, I am very happy to see you progressing so fast in the 
development of your VMEnters/VMExits matching analysis. I have several 
comments concerning the code (see below).

On 16.04.21 г. 19:46, Stefano De Venuto wrote:
> Add a tool in examples/ that scans a merged host + guest trace and
> search for host events that are inside a vmentry/vmexit block (and
> vice-versa for guest events ouside the block) and report the found
> ones.
>
> It can be useful as a starting point for identifying issues of for
> checking the effectiveness of host/guest traces synchronization, or
> even for improving the placing of the tracepoints in the kernel.
>
> Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
> ---
>   examples/checker.c | 202 +++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 202 insertions(+)
>   create mode 100644 examples/checker.c
>
> diff --git a/examples/checker.c b/examples/checker.c
> new file mode 100644
> index 0000000..0b04343
> --- /dev/null
> +++ b/examples/checker.c
> @@ -0,0 +1,202 @@

The first problem is that this patch fails to apply. My guess is that 
you hand-edited the patch and removed some lines starting with "+". Note 
that the total number of additions and removals in the file is indicated 
in the line above. If this number does not match the number of lines 
starting with "+", the patch will fail to apply.

As a general advise - try to avoid hand-editing patches unless you are 
certain you know what you are doing.

Another general problem is that your patch seems to use CRLF for 
indicating new lines. This makes git produce a lot of warnings.

Please fix this in version 2.

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
> +int is_guest(int stream_id,
> +	      struct kshark_host_guest_map* mapping,
> +	      int n_mapping, int* host)
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
> +void print_entry(struct kshark_entry* entry)
> +{
> +	struct kshark_data_stream* stream;
> +	char* event_name;
> +	int stream_id;
> +
> +	stream = kshark_get_stream_from_entry(entry);
> +	event_name = kshark_get_event_name(entry);
> +
> +	stream_id = stream->stream_id;
> +	printf("%d: %s-%d, %lld [%03d]:%s\t%s\n",
> +		stream->stream_id,
> +		kshark_get_task(entry),
> +		kshark_get_pid(entry),
> +		entry->ts,
> +		entry->cpu,
> +		event_name,
> +		kshark_get_info(entry));
> +
> +}
> +

Remove the empty line at the end of the function.


> +void print_entries(struct kshark_entry **entries, ssize_t n_entries)
> +{
> +	for (int i = 0; i < n_entries; ++i
> +		print_entry(entries[i]);
> +}
> +

This function looks like a dead code. It must be removed if you don't 
use it.

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
> +
> +	kshark_close_all(kshark_ctx);
> +	kshark_free(kshark_ctx);

kshark_free() calls kshark_close_all() internally. No need to have both.

Also, since this function is called "free_data" and kshark_free() has 
nothing to do with "data", it may be better to move the call of 
kshark_free() outside, and place it in main().


> +}
> +
> +int main(int argc, char **argv)
> +{
> +
Remove the empty line here.
> +	struct kshark_host_guest_map* host_guest_mapping;
> +	struct custom_stream** custom_streams;
> +	struct custom_stream* custom_stream;
> +	struct custom_stream* host_stream;
> +	struct kshark_data_stream* stream;
> +	struct kshark_context* kshark_ctx;
> +	struct kshark_entry** entries;
> +	struct kshark_entry* current;
> +	ssize_t n_entries;
> +	char* event_name;
> +	char* token;
> +	int n_guest;
> +	char* info;
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
> +		custom_stream = malloc(sizeof(*custom_stream));
> +		custom_stream->original_stream = kshark_get_data_stream(kshark_ctx, sd);
> +		custom_stream->cpus = malloc(custom_stream->original_stream->n_cpus * sizeof(int));
> +		memset(custom_stream->cpus, -1, custom_stream->original_stream->n_cpus * sizeof(int));

Add a comment explaining why you are doing this.


> +
> +		custom_streams[i-1] = custom_stream;
> +	}
> +
> +	host_guest_mapping = NULL;
> +	n_guest = kshark_tracecmd_get_hostguest_mapping(&host_guest_mapping);
> +	if (n_guest < 0) {
> +	  printf("Failed mapping: %d\n", n_guest);
> +	  return 1;
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
> +			if (!strcmp(event_name, KVM_ENTRY)) {
> +
> +				/*
> +				 * The recovering process of the vCPU field of the kvm_entry event
> +				 * is done by splitting the info field.
> +				 */
> +				info = kshark_get_info(current);
> +
> +				token = strtok(info, " ");
> +				token = strtok(NULL, " ");
> +
> +				/* Removing the last comma */
> +				token[strlen(token) - 1] = '\0';
> +
> +				custom_stream->cpus[current->cpu] = atoi(token);

It will be better if you make the recovering of the vCPU above a static 
helper function.


> +
> +				free(info);
> +			} else {
> +				custom_stream->cpus[current->cpu] = -1;
> +			}
> +
> +		} else {
> +
> +			/*
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
> +				if (v_i == host_stream->original_stream->n_cpus) {
> +					printf("%d G out:\t", i);
> +					print_entry(entries[i]);
> +				}
> +
> +			/*
> +			* If the event comes from a host, recover the CPU that executed the event
> +			* and check if it's NOT INSIDE a kvm_entry/kvm_exit block.
> +			*/
> +			} else {
> +				if (custom_stream->cpus[current->cpu] != -1) {
> +					printf("%d H in:\t", i);
> +					print_entry(entries[i]);
> +				}
> +			}
> +		}
> +	}
> +
> +	free_data(kshark_ctx, custom_streams, entries, n_entries, host_guest_mapping, n_guest);
> +}

I do not see how you build the tool. I guess you edited CMakeLists.txt. 
This must be part of the patch as well.

Looking forward to see version 2.

Best,
Yordan



