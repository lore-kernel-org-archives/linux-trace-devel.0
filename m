Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2BAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat,  4 Dec 2021 01:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbhLDBjY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Dec 2021 20:39:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33608 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384003AbhLDBjY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Dec 2021 20:39:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A982FB829E5
        for <linux-trace-devel@vger.kernel.org>; Sat,  4 Dec 2021 01:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDA7C341C0;
        Sat,  4 Dec 2021 01:35:56 +0000 (UTC)
Date:   Fri, 3 Dec 2021 20:35:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 04/25] trace-cmd library: Add internal helper
 function for writing headers before file sections
Message-ID: <20211203203553.5bc05010@gandalf.local.home>
In-Reply-To: <20211111150900.86585-1-tz.stoyanov@gmail.com>
References: <20211111150900.86585-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Nov 2021 17:09:00 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Introduce headers before each file section, in trace file version 7. The
> section header has the following format:
>  <2 bytes>, header ID
>  <string>, null terminated ASCII string, description of the header

We may have discussed this before, but I don't remember. Why did we make
the second item a string? I would think we would want all the fixed size
portions of the header to be first, and the variable size portion to be
last?

 <2 bytes> header ID
 <2 bytes> section flags
 <4 bytes> size of section.

Although, is 4 bytes big enough? Perhaps it should be 8 bytes? What happens
if a section is bigger than 4 gigs?

And then have the string description at the end. Thoughts?

-- Steve


>  <2 bytes>, section flags:
>      1: the section is compressed
>  <4 bytes>, size of the section
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h                 |  5 ++
>  .../include/private/trace-cmd-private.h       |  1 +
>  lib/trace-cmd/include/trace-cmd-local.h       |  5 ++
>  lib/trace-cmd/trace-output.c                  | 68 +++++++++++++++++++
>  4 files changed, 79 insertions(+)
> 
