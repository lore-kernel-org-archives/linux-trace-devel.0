Return-Path: <SRS0=0S24=EJ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BD3C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Nov 2020 13:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E50E622384
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Nov 2020 13:38:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CqO3RN9W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgKCNin (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgKCNin (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Nov 2020 08:38:43 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303BFC0613D1
        for <linux-trace-devel@vger.kernel.org>; Tue,  3 Nov 2020 05:38:43 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id 23so3202282wmg.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Nov 2020 05:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9ktov41jgjeshmgGYPsMhqOMMd829yc2w2j2nhu4Ngk=;
        b=CqO3RN9WPF4E3PhpQpCxQgiOXxD7GDS57LD+4sztrmLnZrvL5Al59Q3TDTdIxUclfZ
         BlThwyrKT5NLuM+7J7a2QpYXPJXv14vmuT/7xKQgPN2WTgzMsSOCs8MmmIKZ7x3SDM10
         lpUUNpNq+w3sH49rJOAx19dG+U7zKv2i1V/r83EQ2R2ddHqvOma6Qkw9V4zaOtg0G2hO
         9NW6HT7EdG/8HM2okPvUuH9szgfMpoJbNz8zvejxASYJVxq4Kw5eRkclvXknUMp86g9L
         PMS3pX3ujL0crPZkBs8bN56Zx0Qu2GOWvyoP8VLzIxqB3ceKWC0R9Zh6RCROaf2oeV1J
         Y2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9ktov41jgjeshmgGYPsMhqOMMd829yc2w2j2nhu4Ngk=;
        b=rchenTn8EUaSlBQMjiJj/4bGcdYOALwEaN+eeK+ihOvwDnYwaSE7M2zy6InuOf6mO9
         Diz2YcPxJgBlYD7C10HdWhV2fcaCb+qI/MMMdWF33w6T0rkacr6TuTRh5EszR2Bm478w
         lADALdZl4Vb/XPNCjfOg4gxVASX+bmDPW90sLROWn789+MMHLVGvjN7zY8wKTW5LOL24
         Ds4alnmaU48ZAYl9m07VcCPgRNyRhj4c2azllEy4EwSJhqt2qa4v3v/+sSoJQBqilEB5
         GjlIC11OoG7C5AXiL2C39se5303xHkNymWIaHpCfApDGdGy8R7CkL0CdcL/2rktZsD2K
         HEZg==
X-Gm-Message-State: AOAM5301admbT02EYUnU+LM2Hxuy5GItS21yASIswmHs1fN/SJck4C1y
        jqvCwDt7T6IKzseiq/4pNAaK3tPK16g=
X-Google-Smtp-Source: ABdhPJzBaAbPbeY5Noj9W9uoqK3u9xYOKX+GCUViIAREWvxeup8FLNxYdHfcGKuooHRPkdsytnFqsg==
X-Received: by 2002:a1c:205:: with SMTP id 5mr3582429wmc.7.1604410721621;
        Tue, 03 Nov 2020 05:38:41 -0800 (PST)
Received: from [192.168.0.108] ([84.40.73.7])
        by smtp.gmail.com with ESMTPSA id f17sm2990299wmf.41.2020.11.03.05.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 05:38:41 -0800 (PST)
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
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <fcb51e5e-c60f-0b58-198a-6f9d01942a76@gmail.com>
Date:   Tue, 3 Nov 2020 15:38:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029215734.2531c5af@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 30.10.20 г. 3:57 ч., Steven Rostedt wrote:
> On Thu, 29 Oct 2020 16:49:03 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> Maybe I don't understand your idea very well, but I think what you
>> suggest has very different behavior. What I want is the implementation
>> of the interface to stay in the same header file (libkshark.h). In the
>> future we can add more interfaces but this will be again in the same
>> header (libkshark.h).
> 
> Maybe I got confused ;-)
> 
> Is there going to be different interface structures? Why the "void *"
> and not just supply a "struct kshark_data_stream *"?

Hi Steven,

Yes, my idea is that in the future we may decide to change something in 
the interface, or to have a second completely different interface, while 
we may still need to keep the interface version that we have now for 
backward compatibility.

> 
> That way at least you have some kind of type checking when tasks move
> things around. I try to avoid using "void *" because it can easily be
> the source of unwanted bugs, due to the lack of type checking.

What if we define the interface to start with an integer identifier?

/** Data interface identifier. */
typedef enum kshark_data_interface_id {
	/** An interface with unknown type. */
	KS_INVALIDE_INTERFACE,

	/** Generic interface suitable Ftrace data. */
	KS_GENERIC_DATA_INTERFACE,
} kshark_data_interface_id;

/**
  * Structure representing the interface of methods used to operate over
  * the data from a given stream.
  */
struct kshark_generic_stream_interface {
	/** Interface version identifier. */
	int			type; /* MUST BE FIRST ENTRY */

	/** Method used to retrieve the Process Id of the entry. */
	stream_get_int_func	get_pid;

	/** Method used to retrieve the Event Id of the entry. */
	stream_get_int_func	get_event_id;

....

and it can be used like this:

char *kshark_get_aux_field(const struct kshark_entry *entry)
{
	struct kshark_generic_stream_interface *interface;
	struct kshark_data_stream *stream =
		kshark_get_stream_from_entry(entry);

	....

	interface = stream->interface;
	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
	    interface->aux_field)
		return interface->aux_field(stream, entry);

	return NULL;
}

What do you think?


Thanks a lot!
Yordan


> 
> -- Steve
> 
