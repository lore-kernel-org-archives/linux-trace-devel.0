Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB265C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CEC164FE9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 14:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhCKOz1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 09:55:27 -0500
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:57029 "EHLO
        smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbhCKOzI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 09:55:08 -0500
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2021 09:55:07 EST
Received: from localhost (styx [192.168.200.7])
        by smtpx.feld.cvut.cz (Postfix) with ESMTP id 5A66E1733A;
        Thu, 11 Mar 2021 15:48:42 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.feld.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id QyGFPoO_OnEE; Thu, 11 Mar 2021 15:48:40 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (Authenticated sender: sojkam1)
        by smtpx.feld.cvut.cz (Postfix) with ESMTPSA id A50A1171FF;
        Thu, 11 Mar 2021 15:48:40 +0100 (CET)
Received: (nullmailer pid 26873 invoked by uid 1000);
        Thu, 11 Mar 2021 14:48:40 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] kernel-shark: Do not hardcode /usr prefix for polkit
 policies
In-Reply-To: <20210311090946.7d24cb40@gandalf.local.home>
References: <20210311131221.13600-1-michal.sojka@cvut.cz>
 <20210311090946.7d24cb40@gandalf.local.home>
Date:   Thu, 11 Mar 2021 15:48:40 +0100
Message-ID: <87mtv97nlj.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Thu, Mar 11 2021, Steven Rostedt wrote:
> On Thu, 11 Mar 2021 14:12:21 +0100
> Michal Sojka <michal.sojka@cvut.cz> wrote:
>
> Hi Michal,
>
> Thanks for the fix!
>
> Note, even when submitting an "obvious" patch, it's always good to add
> some content to the change log body.

Understood. Sending v2...

-Michal
