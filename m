Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6637AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Mar 2022 04:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiCLEv5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Mar 2022 23:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiCLEvz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Mar 2022 23:51:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8D3E9D
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Mar 2022 20:50:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5D39CE2B7C
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Mar 2022 04:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6EFC340EB;
        Sat, 12 Mar 2022 04:50:46 +0000 (UTC)
Date:   Fri, 11 Mar 2022 23:50:44 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: Issue with trace-cmd 3 and kernelshark
Message-ID: <20220311235044.6e416b48@gandalf.local.home>
In-Reply-To: <20220311221825.536d849e@gandalf.local.home>
References: <20220311221825.536d849e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 11 Mar 2022 22:18:25 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> It appears that it doesn't like the fact that the file is compressed. This
> was my worry about compressing date :-/

Actually, it doesn't look like this is an issue with compression, but the
fact that the cpu involved doesn't have any data, and we no longer save
anything for that case.

The problem data is here: 
  https://rostedt.org/private/trace-data/gentoo/trace.dat
  https://rostedt.org/private/trace-data/gentoo/trace-gentoo.dat

And do a: kernelshark trace.dat -a trace-gentoo.dat

-- Steve
