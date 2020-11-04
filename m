Return-Path: <SRS0=4MoQ=EK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83505C2D0A3
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Nov 2020 15:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D9422072C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Nov 2020 15:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbgKDPlo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Nov 2020 10:41:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728380AbgKDPlo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Nov 2020 10:41:44 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 521A1206F4;
        Wed,  4 Nov 2020 15:41:43 +0000 (UTC)
Date:   Wed, 4 Nov 2020 10:41:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 07/20] kernel-shark: Add basic methods for Data
 streams
Message-ID: <20201104104140.77de9fc3@gandalf.local.home>
In-Reply-To: <fcb51e5e-c60f-0b58-198a-6f9d01942a76@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
        <20201012133523.469040-8-y.karadz@gmail.com>
        <20201012201847.1218c974@oasis.local.home>
        <d67dd724-abe1-3696-29f7-75358f98df87@gmail.com>
        <20201029100421.33720af1@gandalf.local.home>
        <b24331bb-a8e3-5347-62e5-ed9b630c0601@gmail.com>
        <20201029215734.2531c5af@oasis.local.home>
        <fcb51e5e-c60f-0b58-198a-6f9d01942a76@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 3 Nov 2020 15:38:33 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> What if we define the interface to start with an integer identifier?
> 
> /** Data interface identifier. */
> typedef enum kshark_data_interface_id {
> 	/** An interface with unknown type. */
> 	KS_INVALIDE_INTERFACE,
> 
> 	/** Generic interface suitable Ftrace data. */
> 	KS_GENERIC_DATA_INTERFACE,
> } kshark_data_interface_id;
> 
> /**
>   * Structure representing the interface of methods used to operate over
>   * the data from a given stream.
>   */
> struct kshark_generic_stream_interface {
> 	/** Interface version identifier. */
> 	int			type; /* MUST BE FIRST ENTRY */
> 
> 	/** Method used to retrieve the Process Id of the entry. */
> 	stream_get_int_func	get_pid;
> 
> 	/** Method used to retrieve the Event Id of the entry. */
> 	stream_get_int_func	get_event_id;
> 
> ....
> 
> and it can be used like this:
> 
> char *kshark_get_aux_field(const struct kshark_entry *entry)
> {
> 	struct kshark_generic_stream_interface *interface;
> 	struct kshark_data_stream *stream =
> 		kshark_get_stream_from_entry(entry);
> 
> 	....
> 
> 	interface = stream->interface;
> 	if (interface->type == KS_GENERIC_DATA_INTERFACE &&
> 	    interface->aux_field)
> 		return interface->aux_field(stream, entry);
> 
> 	return NULL;
> }
> 
> What do you think?


This was actually what I was getting at ;-)

That is a common practice in the Linux kernel.

-- Steve
