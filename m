Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CB1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Mar 2022 15:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbiCPPFR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 11:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241454AbiCPPFQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 11:05:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623AE1BE8A
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 08:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13547B81B0B
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 15:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA92C340E9;
        Wed, 16 Mar 2022 15:03:58 +0000 (UTC)
Date:   Wed, 16 Mar 2022 11:03:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel-shark: CPU plots dialog ease spotting empty
 CPUs
Message-ID: <20220316110356.70d84b3a@gandalf.local.home>
In-Reply-To: <20220316143717.272899-2-y.karadz@gmail.com>
References: <20220316143717.272899-1-y.karadz@gmail.com>
        <20220316143717.272899-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Mar 2022 16:37:17 +0200
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The CPU plots dialog will show only the ones with content. A "hide empty"
> checkbox is added, that by default is checked. If it is unchecked, then
> all the CPUs would show up.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215677
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>

This is awesome Yordan!

It's exactly what I was looking for.

Tested-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Although, I found that if I select more that 16 CPU plots at a time it
hangs. I can add that to the BZ. (I noticed this before these patches).

-- Steve
