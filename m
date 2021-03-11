Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB610C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 17:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A484064FE9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 17:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbhCKR5h (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 12:57:37 -0500
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:49125 "EHLO
        smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCKR5G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 12:57:06 -0500
Received: from localhost (styx [192.168.200.7])
        by smtpx.feld.cvut.cz (Postfix) with ESMTP id B605217BC6;
        Thu, 11 Mar 2021 18:57:04 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.feld.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id 7QCzyC0mDpOJ; Thu, 11 Mar 2021 18:57:02 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (Authenticated sender: sojkam1)
        by smtpx.feld.cvut.cz (Postfix) with ESMTPSA id C993917C6B;
        Thu, 11 Mar 2021 18:57:00 +0100 (CET)
Received: (nullmailer pid 7979 invoked by uid 1000);
        Thu, 11 Mar 2021 17:57:00 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] kernel-shark: Do not hardcode /usr prefix for polkit
 policies
In-Reply-To: <cf3243d3-65e0-18cd-0a20-81739552c105@gmail.com>
References: <87mtv97nlj.fsf@steelpick.2x.cz>
 <20210311145059.27147-1-michal.sojka@cvut.cz>
 <cf3243d3-65e0-18cd-0a20-81739552c105@gmail.com>
Date:   Thu, 11 Mar 2021 18:57:00 +0100
Message-ID: <87k0qd7evn.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Yordan,

On Thu, Mar 11 2021, Yordan Karadzhov (VMware) wrote:
> In your case the installation fails to install the policy file used by
> Polkit. Note that this doesn't mean that the kernelshark installation 
> itself fails.

Yes, I know, but when something fails, users are confused ;-)

> As far as I know the policy file can only go to a special locations so 
> that Polkit can find it. Otherwise it will have no effect (I may be 
> wrong on this).

You're right. I looked at polkit sources and it really seems that only
one location is supported. It is determined at configuration time so on
some systems it may be different from /usr/share/... I'm talking
specifically about NixOS, but it already has the patch I sent.

So I leave it up to you whether to apply the patch or not. I think that
supporting seamless installation into $HOME is useful if one wants to
quickly use a newer version not available in their distribution.

BTW, thanks for great tool!

-Michal
