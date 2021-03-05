Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA9FC433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 14:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA21064FE1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 14:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhCEOrv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 09:47:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhCEOrq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 09:47:46 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70F7B64FD4;
        Fri,  5 Mar 2021 14:47:45 +0000 (UTC)
Date:   Fri, 5 Mar 2021 09:47:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     raistlin.df@gmail.com
Cc:     Stefano De Venuto <stefano.devenuto99@gmail.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [RFC] Open multiple trace files and, if possible, pair them
Message-ID: <20210305094744.2a8e6a08@gandalf.local.home>
In-Reply-To: <014e41015f59d4be9a816398302e892897efb244.camel@gmail.com>
References: <20210305062807.2734-1-stefano.devenuto99@gmail.com>
        <014e41015f59d4be9a816398302e892897efb244.camel@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 05 Mar 2021 10:18:07 +0100
raistlin.df@gmail.com wrote:

> For Stefano: about the patch itself, I think the only thing I'm going
> to say is that some of the lines look a bit long.
> 
> I do not see a CODING_STYLE file in the repo, but just looking around,
> I got the impression that we should stay within 76-80 characters all
> the times that it is possible.

Honestly, I'm not a fan of the 80 character limit. I don't want lines that
are 200 characters long either. My windows are normally between 90 and 100
characters wide, so keeping it under 100 is fine with me. Especially if it
keeps the code looking better.

For example:


+			current_trace_id = tracecmd_get_traceid(handles->handle);
+			if (tracecmd_get_guest_cpumap(peer_handle, current_trace_id,
+							NULL, NULL, NULL) != -1)
+				tracecmd_pair_peer(handles->handle, peer_handle);


Should be either:

			current_trace_id = tracecmd_get_traceid(handles->handle);
			if (tracecmd_get_guest_cpumap(peer_handle, current_trace_id, NULL, NULL, NULL) != -1)
				tracecmd_pair_peer(handles->handle, peer_handle);


or:

			current_trace_id = tracecmd_get_traceid(handles->handle);
			if (tracecmd_get_guest_cpumap(peer_handle, current_trace_id,
						      NULL, NULL, NULL) != -1) {
				tracecmd_pair_peer(handles->handle, peer_handle);
			}

Two changes above:

If you break a if conditional up, that categorizes it as a "complex"
statement and brackets should be used. (This is also for Linux kernel
coding style).

The second is, if you break up a function call parameters, the parameters
starting on the next line should line up with the starting parenthesis.
Note, this is not always the case. If the broken line is still long, it is
OK to have the line start before the parenthesis to keep it symmetrical:

			current_trace_id = tracecmd_get_traceid(handles->handle);
			if (tracecmd_get_guest_cpumap(peer_handle, current_trace_id,
					some_string, another_string, bigger_string_as_well) != -1) {
				tracecmd_pair_peer(handles->handle, peer_handle);
			}

But that too should be avoided if possible.

Thanks!

-- Steve
