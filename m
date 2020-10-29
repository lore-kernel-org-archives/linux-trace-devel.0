Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495EFC4363A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 14:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58B4206E3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 14:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iRycY7XT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgJ2OtG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 10:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgJ2OtF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 10:49:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A97CC0613D2
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 07:49:05 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x7so3097886wrl.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 07:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K8kY4vJZ/1z94QQpk6B2EczjREFZxvpY97IQPlVVqn8=;
        b=iRycY7XTmhlNcLs/pamh6KOakUu/l7DrVwSU1DvyXWRyVS9EqEQZ4av9T054S7rGmI
         LV9axDEU3oIoc6Z1WKbSfDuDZBwG5gXWINYGjlIDuGITkmR5RNczpwSqL9aPomxozrO2
         fqN7i7H6v8Kkm5cm1VmHaPNdSzdXIziukDTrJddwgmLxCCV7QpqOg44v4+onHjCUu8hP
         +k7o45r+Elg7qkI/uzcniokuTOq7CDLPOcq/39IzeNKRp9u3gQi/RRoeZI4LeVl/7ddm
         M6m7Lz/rR9erXyLp3SFF3dAK9Y9XEU8xPt04nAdrNLc/CK9la+reFpqAZBIkh6l+iTMM
         lknw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K8kY4vJZ/1z94QQpk6B2EczjREFZxvpY97IQPlVVqn8=;
        b=IgnbfcOR6OzP6I3qbPh9rlQtSybH6khr80XvGsu5+KCceVgVBeXI018mUfZ+kvHLmB
         TcZjeAv0VPXAm9hHVPRzxD6vHiOA9Kg7Y4ARm2v6jD+NfVkl4gA9TGVq298YnIsgxUq2
         j8QwQYJtswW9rKCoAU31oX4wBSji411u9j/eqolW4FqBy8EnyRFm1hmH1YJY52dgYQke
         XPS2Zi0C/GV4YC6Husm+en4dRTqO6q1iKp85fTYG0d7/Kswaad/vm0bcc5V9ELG7V2yp
         0d9aAFlGq3BMRXzw2cjfKtfCSOIxEAOur9oNX2Mj6Rc+QIHerCNK18zm9zL3myZNHY1l
         +t8Q==
X-Gm-Message-State: AOAM53137qPru0ROYv8VdvyCrKTQUft644WNBFfGL7TH4b4K66SFtazg
        TKwXeEAexUh3+I2tCNCL5R24wYnmkp8=
X-Google-Smtp-Source: ABdhPJyIkWFmFXtJhgcbASO9zUmKvHgE/JTM3Ur775EehqHbrxPG9gzqiklld1TLbUckRXx2nXJ9Bg==
X-Received: by 2002:adf:edcf:: with SMTP id v15mr5745724wro.291.1603982943875;
        Thu, 29 Oct 2020 07:49:03 -0700 (PDT)
Received: from [10.93.171.156] ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id z14sm154939wmc.15.2020.10.29.07.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 07:49:03 -0700 (PDT)
Subject: Re: [PATCH v2 07/20] kernel-shark: Add basic methods for Data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-8-y.karadz@gmail.com>
 <20201012201847.1218c974@oasis.local.home>
 <d67dd724-abe1-3696-29f7-75358f98df87@gmail.com>
 <20201029100421.33720af1@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <b24331bb-a8e3-5347-62e5-ed9b630c0601@gmail.com>
Date:   Thu, 29 Oct 2020 16:49:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029100421.33720af1@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 29.10.20 г. 16:04 ч., Steven Rostedt wrote:
> On Thu, 29 Oct 2020 12:10:36 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>>>> +/**
>>>> + * @brief Get the name of the command/task from its Process Id.
>>>> + *
>>>> + * @param sd: Data stream identifier.
>>>> + * @param pid: Process Id of the command/task.
>>>> + */
>>>> +char *kshark_comm_from_pid(int sd, int pid)
>>>
>>> I wonder if we should abstract this further, and call it
>>> "kshark_name_from_id()", as comm and pid are specific to processes, and
>>> we may have a stream that will represent something other than processes.
>>>    
>>
>> This is just a helper function that wraps the corresponding method of
>> the interface. In the future we can add a similar helper/wrapper
>> function with different name if we have streams that contain no processes.
>>
>> However, you are actually making a very good point. It may be even
>> better if we abstract the interface itself, instead of trying to have
>> more abstract method names. We can keep the existing interface of
>> methods unchanged, but in the definition of "struct kshark_data_stream"
>> make the interface void*
>>
>> struct kshark_data_stream {
>> 	/** Data stream identifier. */
>> 	uint8_t			stream_id;
>>
>> ....
>>
>> 	/** List of Plugin's Draw handlers. */
>> 	struct kshark_draw_handler		*draw_handlers;
>>
>> 	/**
>> 	 * Abstract interface of methods used to operate over the data
>> 	 * from a given stream. An implementation must be provided.
>> 	 */
>> 	void	*interface;
>> };
>>
>> and then the wrapping functions may look like this
>>
>> char *kshark_comm_from_pid(int sd, int pid)
>> {
>> 	struct kshark_data_stream_interface *interface;
>> 	struct kshark_context *kshark_ctx = NULL;
>> 	struct kshark_data_stream *stream;
>> 	struct kshark_entry e;
>>
>> 	if (!kshark_instance(&kshark_ctx))
>> 		return NULL;
>>
>> 	stream = kshark_get_data_stream(kshark_ctx, sd);
>> 	if (!stream)
>> 		return NULL;
>>
>> 	interface = stream->interface;
>> 	if (!interface || !interface->get_task)
>> 		return NULL;
>>
>> 	e.visible = KS_PLUGIN_UNTOUCHED_MASK;
>> 	e.pid = pid;
>>
>> 	return interface->get_task(stream, &e);
>> }
>>
>> And in the future we can add more interface implementations and more
>> helper functions.
>>
>> What do you think?
> 
> 
> Do we need to make the interface "void *" and not just a non defined type
> "struct kshark_data_stream_interface *"?
> 
> Just have:
> 
> struct kshark_data_stream_interface;
> 
> And then reference it without defining it, and have the streams define it.
> If you need this to have inheritance and a bit of polymorphism you can do
> that too :-) That is, if you want this interface to have something common
> among all streams.
> 

Maybe I don't understand your idea very well, but I think what you 
suggest has very different behavior. What I want is the implementation 
of the interface to stay in the same header file (libkshark.h). In the 
future we can add more interfaces but this will be again in the same 
header (libkshark.h).

The readout plugins will include libkshark.h and will have to chose one 
of the available interfaces and implement its methods like this:

static int kshark_tep_stream_init(struct kshark_data_stream *stream,
				  struct tracecmd_input *input)
{
	struct kshark_data_stream_interface *interface;

	stream->interface = interface = calloc(1, sizeof(*interface));
	if (!interface)
		return -ENOMEM;

....

	interface->get_pid = tepdata_get_pid;
	interface->get_task = tepdata_get_task;
	interface->get_event_id = tepdata_get_event_id;

....

Note that the plugins will include libkshark.h but libkshark will never 
include headers from plugins.

Does it make any sense, or maybe I just don't understand your suggestion?

Thanks a lot!
Yordan

> struct kshark_data_stream_interface {
> 	int		type;
> 	int		common_data;
> };
> 
> then local to the file that implements it:
> 
> struct data_stream_interface {
> 	struct kshark_data_stream_interface	kinterface;
> 	int					unique_data;
> };
> 
> 
> {
> 	struct data_stream_interface	*interface;
> 
> 
> 	interface = (struct data_stream_interface *)stream->interface;
> 
> 	if (interface->kinterface.type != my_type)
> 		return (or error);
> 
> 	unique_data = interface->unique_data;
> 
> }
> 
> 
> This is even how the trace events work in the kernel. For example:
> 
> struct trace_entry {
> 	unsigned short		type;
> 	unsigned char		flags;
> 	unsigned char		preempt_count;
> 	int			pid;
> };
> 
> struct kprobe_trace_entry_head {
> 	struct trace_entry	ent;
> 	unsigned long		ip;
> };
> 
> struct kretprobe_trace_entry_head {
> 	struct trace_entry	ent;
> 	unsigned long		func;
> 	unsigned long		ret_ip;
> };
> 
> -- Steve
> 
