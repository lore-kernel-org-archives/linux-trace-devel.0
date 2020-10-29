Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E0D5C55178
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:16:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C437C20756
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:16:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tbqLoTAs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgJ2LQo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgJ2LQn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:16:43 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4F3C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:16:42 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id w14so2287728wrs.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T7olYgg7FYC9a7k9rhjw90CrDfYzcLL3KKdkEqykVCo=;
        b=tbqLoTAsorHFfUTzOlaZ8VW0rC6WAJkNr5FoWpj8amsS/vVa3Gjwkqty6LPcZjDOzW
         Pa/M0m9bgwwuROqP066CZi8bwXBX6U9DXhx0W5CbYwtYsdTr4nh0NLhzquUkEo2uOGkA
         LEPof8OWqsmQmH0Mm5TnaUJ4A8CFTJMB1H6UyF6JW6VnmXV1/TY9Y6OIkXBUVIJ/79uh
         znYoUJFv3pomkmNOiZQT2nbJEusQ7dHLvhsrMS3foEobW0flPaUNyxTkUs8Vw/T/MWun
         O5JgV0ebHLJTRoKGU05Wy64lKcvJ6FqH95PRBgPoGTxKpFK6k2orl9cDD1g9/Kp8sJs2
         dgiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T7olYgg7FYC9a7k9rhjw90CrDfYzcLL3KKdkEqykVCo=;
        b=SFTy2ChB/R0fcu7mm+2o21kMOIWpUSacp1fOa1skbzCuUCDZeuCKo5j5nooNJY9tVk
         KlU0oegZ9wGZ2Ofa6zAWkTTSFMAXWXj24g22DcjGKuj8RSaWTKZXNYInMhAkJ2OL4Tp0
         Cqqa19Viy0A+2Oosa5S9C0aLC4mmAWlKaJMaFRmtXQUm/UKvYo8PyxIABEAXviygQCkS
         8QUqV4D9SYPFsBUu+Du0JuDaPPMum8YVrPSujshJU5xtWDHcG4p/fq880eClABu5Rtnd
         +kPytNVbrInLXR7qtDINmdRhyIvorBjQQbtu8Vv/DOABbXX+5i2OsmDuUc77g7QuI7sb
         RiAg==
X-Gm-Message-State: AOAM530uaLwPmSjWGaNPF960P8qBULkhx1eYt5weAR2YaVx0XDi0k89v
        37Gxo1eVh7+VwvQnLd3Rg38lBb1lVgU=
X-Google-Smtp-Source: ABdhPJzxdKghKiq25q9RDNQl5StUVeV8U0jr7hpGeA4rl98Gy45Lt8TYZ+9T1wTrE+reAE0fxF7MsQ==
X-Received: by 2002:adf:f007:: with SMTP id j7mr5143719wro.73.1603970201376;
        Thu, 29 Oct 2020 04:16:41 -0700 (PDT)
Received: from [192.168.0.108] ([84.40.73.62])
        by smtp.gmail.com with ESMTPSA id z15sm4359555wrq.24.2020.10.29.04.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 04:16:40 -0700 (PDT)
Subject: Re: [PATCH v2 09/20] kernel-shark: Add stream interface for trace-cmd
 data
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-10-y.karadz@gmail.com>
 <20201012204418.3274438e@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <7857fc2f-0fca-8e0a-9b3f-c5f23e2389b1@gmail.com>
Date:   Thu, 29 Oct 2020 13:16:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012204418.3274438e@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 13.10.20 г. 3:44 ч., Steven Rostedt wrote:
> On Mon, 12 Oct 2020 16:35:12 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Here we provide an implementation of the Data stream interface that will
>> process the trace-cmd (Ftrace) data. This can be considered the most
>> essential change in the transformation of the C API towards version 2.
>> However, for the moment we only have stand alone definitions that are not
>> made functional yet. The actual integration with the API will be
>> introduced in the following patches.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
> 
> 
>> +
>> +static ssize_t get_records(struct kshark_context *kshark_ctx,
>> +			   struct kshark_data_stream *stream,
>> +			   struct rec_list ***rec_list,
>> +			   enum rec_type type)
>> +{
>> +	struct tep_event_filter *adv_filter = NULL;
>> +	struct rec_list **temp_next;

....

>> +	ret = tep_read_number_field(evt_field, record->data,
>> +				    (unsigned long long *) val);
>> +	free_record(record);
>> +
>> +	return ret;
>> +}
>> +
>> +/** Initialize all methods used by a stream of FTRACE data. */
>> +static void kshark_tep_init_methods(struct kshark_data_stream *stream)
>> +{
>> +	stream->interface.get_pid = tepdata_get_pid;
>> +	stream->interface.get_task = tepdata_get_task;
>> +	stream->interface.get_event_id = tepdata_get_event_id;
>> +	stream->interface.get_event_name = tepdata_get_event_name;
>> +	stream->interface.get_latency = tepdata_get_latency;
> 
> Since "latency" is a very specific field,  I wonder if we should call
> this "aux_field", and have a way to express what to show in the table.
> That is, if there's not a "aux_field" defined, it ignores it. Not all
> streams may have this.
> 


This is a good idea. I will change it in v3 and will fix all the issues 
you pointed out above.

Thanks!
Yordan


> -- Steve
> 
>> +	stream->interface.get_info = tepdata_get_info;
>> +	stream->interface.find_event_id = tepdata_find_event_id;
>> +	stream->interface.get_all_event_ids = tepdata_get_event_ids;
>> +	stream->interface.dump_entry = tepdata_dump_entry;
>> +	stream->interface.get_all_field_names = tepdata_get_field_names;
>> +	stream->interface.get_event_field_type = tepdata_get_field_type;
>> +	stream->interface.read_record_field_int64 = tepdata_read_record_field;
>> +	stream->interface.read_event_field_int64 = tepdata_read_event_field;
>> +	stream->interface.load_entries = tepdata_load_entries;
>> +	stream->interface.load_matrix = tepdata_load_matrix;
>> +}
>> +
