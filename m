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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AD5C433ED
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 May 2021 06:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D692613F0
	for <linux-trace-devel@archiver.kernel.org>; Sat,  1 May 2021 06:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhEAGMH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 1 May 2021 02:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhEAGMH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 1 May 2021 02:12:07 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE3DC06174A
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Apr 2021 23:11:17 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id zg3so331225ejb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 30 Apr 2021 23:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=li2AE6Uq3MuW5JPmYnBqoyS1Up0BeHkHx509bA4j8u4=;
        b=Vj/dAO5mtdLLy7VldnUKVy0KgBEwFyVLp79x9r9vykZE8ogJxt6GSwPR9goWFQ4HEn
         i0xrrNJ+wZHWQ7lKpRKMGtag4tAFWB4l87TUNEMDxQwoWZpmSwQdUDNPcYknMzafkCR2
         muT+pjazYbnUqpn1LYHFWAc8568iuXXT32e2EcdKo6M2Tyqf6ZuBQ3tMF6aI8VwY/rL/
         x5ax3ODD8a+ScAJOx0KVWSslESNKem9bZh/nK7n52U/HXhSfDEAx4hA1iNM+lty11oJq
         CdkLw8m/Po3Fit2kObAE31PV0xXCjgoTim1Gsn3UpQZyaE9MJ7qN1TKkro1BO4l+J+Ur
         AmBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=li2AE6Uq3MuW5JPmYnBqoyS1Up0BeHkHx509bA4j8u4=;
        b=hZ3sz0kWlu5xG+ofdo31/m23h6L9C5qQ+EkooYZsfWfEeTL0oc4SaU59T7Jb7eSVmw
         QGjy6Wk3yyeprsZzezr/uZ5kEPll2MqOCvgh/aMGMVaCssFdJXeh+iUMYqWyB0VJrPT8
         gRpuA651RMPqT3YxJfeEAV9lquieVXjtvNn5v1vMPXNv8RA3Umintayo4EfLR0MNeIPQ
         W+TKQuqt36I2w9ZQTY6KoXaU8LEFDs0nPhYFdFAgA4RXr7hfaqClOcuvRLczDM6pH8OZ
         N2q5UsVYRZzLg7Mv4gt44t+LpsFxQ8CItIZs1/sXb2VLl0987s42YtF+ALQdOa/mVd+L
         bw8w==
X-Gm-Message-State: AOAM530pS3Ga8Kz07dNt+GHoR9B6oadmFO1Hatwh3TcQp/+99UMETa1v
        ROPkkzlwt+RzLDmpCdxJQtY=
X-Google-Smtp-Source: ABdhPJxWupnW/X2dr0I7nU0rhwSfZgpn7B8WtmA4m6HRmg0M8piEQWNI4TflYeA+VUrdkT+X++a6GQ==
X-Received: by 2002:a17:906:cb2:: with SMTP id k18mr7955317ejh.183.1619849476163;
        Fri, 30 Apr 2021 23:11:16 -0700 (PDT)
Received: from localhost.localdomain ([151.32.59.148])
        by smtp.gmail.com with ESMTPSA id hc43sm4350207ejc.97.2021.04.30.23.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 23:11:15 -0700 (PDT)
Subject: Re: [RFC] Simple tool for VMEnters/VMExits matching and trace
 validation
To:     Yordan Karadzhov <y.karadz@gmail.com>, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, dfaggioli@suse.com
References: <20210416164653.2949-1-stefano.devenuto99@gmail.com>
 <7edad92d-3297-fd42-9ac2-0334816fb524@gmail.com>
From:   Stefano De Venuto <stefano.devenuto99@gmail.com>
Message-ID: <6630d3a1-629f-bde4-b34e-ce8fb307a6f7@gmail.com>
Date:   Sat, 1 May 2021 08:11:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <7edad92d-3297-fd42-9ac2-0334816fb524@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ciao Yordan,

Thanks so much for the comments!
I've just sent the version 2 addressing them.

On 4/20/21 10:12 AM, Yordan Karadzhov wrote:
> Ciao Stefano,
> 
> First of all, I am very happy to see you progressing so fast in the
> development of your VMEnters/VMExits matching analysis. I have several
> comments concerning the code (see below).
> 
> On 16.04.21 г. 19:46, Stefano De Venuto wrote:
>> Add a tool in examples/ that scans a merged host + guest trace and
>> search for host events that are inside a vmentry/vmexit block (and
>> vice-versa for guest events ouside the block) and report the found
>> ones.
>>
>> It can be useful as a starting point for identifying issues of for
>> checking the effectiveness of host/guest traces synchronization, or
>> even for improving the placing of the tracepoints in the kernel.
>>
>> Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
>> ---
>>   examples/checker.c | 202 +++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 202 insertions(+)
>>   create mode 100644 examples/checker.c
>>
>> diff --git a/examples/checker.c b/examples/checker.c
>> new file mode 100644
>> index 0000000..0b04343
>> --- /dev/null
>> +++ b/examples/checker.c
>> @@ -0,0 +1,202 @@
> 
> The first problem is that this patch fails to apply. My guess is that
> you hand-edited the patch and removed some lines starting with "+". Note
> that the total number of additions and removals in the file is indicated
> in the line above. If this number does not match the number of lines
> starting with "+", the patch will fail to apply.
> 
> As a general advise - try to avoid hand-editing patches unless you are
> certain you know what you are doing.
> 

Ok, thanks for the advice!

>> +
>> +        custom_streams[i-1] = custom_stream;
>> +    }
>> +
>> +    host_guest_mapping = NULL;
>> +    n_guest =
>> kshark_tracecmd_get_hostguest_mapping(&host_guest_mapping);
>> +    if (n_guest < 0) {
>> +      printf("Failed mapping: %d\n", n_guest);
>> +      return 1;
>> +    }
>> +
>> +    entries = NULL;
>> +    n_entries = kshark_load_all_entries(kshark_ctx, &entries);
>> +
>> +    for (int i = 0; i < n_entries; ++i) {
>> +        current = entries[i];
>> +
>> +        stream = kshark_get_stream_from_entry(current);
>> +        event_name = kshark_get_event_name(current);
>> +
>> +        custom_stream = custom_streams[stream->stream_id];
>> +
>> +        if (!strcmp(event_name, KVM_ENTRY) || !strcmp(event_name,
>> KVM_EXIT)) {
>> +            if (!strcmp(event_name, KVM_ENTRY)) {
>> +
>> +                /*
>> +                 * The recovering process of the vCPU field of the
>> kvm_entry event
>> +                 * is done by splitting the info field.
>> +                 */
>> +                info = kshark_get_info(current);
>> +
>> +                token = strtok(info, " ");
>> +                token = strtok(NULL, " ");
>> +
>> +                /* Removing the last comma */
>> +                token[strlen(token) - 1] = '\0';
>> +
>> +                custom_stream->cpus[current->cpu] = atoi(token);
> 
> It will be better if you make the recovering of the vCPU above a static
> helper function.
> 

I totally replaced that method since with
kshark_read_event_field_int(entry, "vcpu_id", &vcpu) I can get this
information in such a cleaner way!
Also more robust, since plugins can remove the vcpu field from the info.

Regards,
Stefano

