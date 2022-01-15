Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD31C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 12:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiAOM67 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 07:58:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60036 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiAOM67 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 07:58:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28A8260C68
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 12:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DA2C36AE3;
        Sat, 15 Jan 2022 12:58:57 +0000 (UTC)
Date:   Sat, 15 Jan 2022 07:58:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 05/25] trace-cmd library: Add internal helper
 function for writing headers before file sections
Message-ID: <20220115075856.7c5f325d@rorschach.local.home>
In-Reply-To: <20211210105448.97850-6-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:28 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Introduce headers before each file section, in trace file version 7. The
> section header has the following format:
>  <2 bytes>, header ID
>  <4 bytes>, offset within the strings section, where the section
>             description string is located.
>  <2 bytes>, section flags:
>      1: the section is compressed

Would in make more sense to have the ID and flags together, followed by
the string? That way you could use a normal structure to represent it.

struct {
	unsigned short			id;
	unsigned short			flags;
	unsigned int			string_offset;
	unsigned long long		size;
};

Otherwise, all tools to read it will be forced to read each part
individually. I can imaging that being annoying in the future.

-- Steve


>  <8 bytes>, size of the section
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
