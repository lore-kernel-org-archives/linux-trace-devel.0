Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1453C4741F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C6AD2083B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 14:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VzGOQr0f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgKEOgA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 09:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgKEOgA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 09:36:00 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE295C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Nov 2020 06:35:58 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id w1so2040543wrm.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Nov 2020 06:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L62cCTodpH/N195EyAt3AGU4ctadQAgjo85bS0LvTaE=;
        b=VzGOQr0fst2I/OGm9D3xIQ02GbJtJw0+t5XjOCHJYGEzgiVWF6ITva0W+nKYc/bpAl
         eMB/vSfuEZkJd3sO3KmSj/xdnMJb++JCbZNcn4w6LZbP3uKdV7ocaakJHM2b9+nRjLud
         Els0wv3bcdhUpFVkJhFo1F0VMvQbpZrvZNIJG9lElI+TQODW89m4P6aIz/KS7BPZj9vX
         HhuYGUHNJCLuTu+32+J8OyYW63dBQPCyUM0pgUtVC7RIrfTDYCEaw7FyRcHCJQRcDHxo
         2N96pA7SUsH931x5a5VJW0W5Cg6kjNDyPXgHkuUjNyXKZexbj2qYXaF0VZmFf6w9MI94
         ZOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L62cCTodpH/N195EyAt3AGU4ctadQAgjo85bS0LvTaE=;
        b=ewSKscGqiDX9A9MKnnfISteYh5pbk6F4s0DbPoRjd6bTv6VVl+r9HS76FggbK9KFRf
         DsC80WBJUq4IBC+sNAm91KAv3zN7nyHrVz35X61ehuPhFdk+Rdek2RdTPh5GcNOHR6CJ
         DmUe9Bc/k0wTmyzkT0jAWeGxQMWoF/bU8TiwFUmT4oRo/ieNJtsLYCnBFyYXd0ZcPNya
         SQx5bJKBSYra1MsghDbom0UvcH84La2w9CPs8YjcR5nMirX8n8AEEherITBkZqAYk5Hs
         N3fMuqvtOn/miMr3DkYz6q3bJ2hlSX8QfG6edfyKjp8hpygy/A0bp7IWBn/CbZH9ta1h
         Q/9A==
X-Gm-Message-State: AOAM530iYTS/CblwAmR6xymj1KSkowJ2rvd4FglpMPsi188Ff/bTfJtE
        IR3y/XvPn2WU2BnxIlRAP8DK53y8jj8=
X-Google-Smtp-Source: ABdhPJwSAcy8Y53fD2SToOgHEZD6u+SisHtE67WQn6sNIZBCSEH++iGOiKpf+tbha9FVmyt11MP1gA==
X-Received: by 2002:adf:db03:: with SMTP id s3mr3543460wri.152.1604586957356;
        Thu, 05 Nov 2020 06:35:57 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id o17sm2829150wmd.34.2020.11.05.06.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 06:35:55 -0800 (PST)
Subject: Re: [PATCH v2 07/20] kernel-shark: Add basic methods for Data streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201012133523.469040-1-y.karadz@gmail.com>
 <20201012133523.469040-8-y.karadz@gmail.com>
 <20201012201847.1218c974@oasis.local.home>
 <d67dd724-abe1-3696-29f7-75358f98df87@gmail.com>
 <20201029100421.33720af1@gandalf.local.home>
 <b24331bb-a8e3-5347-62e5-ed9b630c0601@gmail.com>
 <20201029215734.2531c5af@oasis.local.home>
 <fcb51e5e-c60f-0b58-198a-6f9d01942a76@gmail.com>
 <20201104104140.77de9fc3@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <5f577b76-cc64-5ffb-14a3-de7ea5d7db86@gmail.com>
Date:   Thu, 5 Nov 2020 16:35:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201104104140.77de9fc3@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 4.11.20 г. 17:41 ч., Steven Rostedt wrote:
> On Tue, 3 Nov 2020 15:38:33 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> What if we define the interface to start with an integer identifier?
>>
>> /** Data interface identifier. */
>> typedef enum kshark_data_interface_id {
>> 	/** An interface with unknown type. */
>> 	KS_INVALIDE_INTERFACE,
>>
>> 	/** Generic interface suitable Ftrace data. */
>> 	KS_GENERIC_DATA_INTERFACE,
>> } kshark_data_interface_id;
>>
>> /**
>>    * Structure representing the interface of methods used to operate over
>>    * the data from a given stream.
>>    */
>> struct kshark_generic_stream_interface {
>> 	/** Interface version identifier. */
>> 	int			type; /* MUST BE FIRST ENTRY */
>>
>> 	/** Method used to retrieve the Process Id of the entry. */
>> 	stream_get_int_func	get_pid;
>>
>> 	/** Method used to retrieve the Event Id of the entry. */
>> 	stream_get_int_func	get_event_id;
>>
>> ....
>>
>> and it can be used like this:
>>
>> char *kshark_get_aux_field(const struct kshark_entry *entry)
>> {
>> 	struct kshark_generic_stream_interface *interface;
>> 	struct kshark_data_stream *stream =
>> 		kshark_get_stream_from_entry(entry);
>>
>> 	....
>>
>> 	interface = stream->interface;
>> 	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
>> 	    interface->aux_field)
>> 		return interface->aux_field(stream, entry);
>>
>> 	return NULL;
>> }
>>
>> What do you think?
> 
> 
> This was actually what I was getting at ;-)
> 
> That is a common practice in the Linux kernel.

OK, thanks a lot!
Will be implemented in v3.

cheers,
Yordan

> 
> -- Steve
> 
