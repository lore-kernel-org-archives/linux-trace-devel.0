Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36760C433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 13:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D01CF64F6A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Mar 2021 13:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhCQM7u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 08:59:50 -0400
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:53317 "EHLO
        smtpx.feld.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhCQM7m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 08:59:42 -0400
Received: from localhost (styx [192.168.200.7])
        by smtpx.feld.cvut.cz (Postfix) with ESMTP id 5866740AC1;
        Wed, 17 Mar 2021 13:59:41 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.feld.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id goKkgeVVUu0a; Wed, 17 Mar 2021 13:59:39 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (Authenticated sender: sojkam1)
        by smtpx.feld.cvut.cz (Postfix) with ESMTPSA id 28BCF40AA0;
        Wed, 17 Mar 2021 13:59:39 +0100 (CET)
Received: (nullmailer pid 10843 invoked by uid 1000);
        Wed, 17 Mar 2021 12:59:38 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dario Faggioli <dfaggioli@suse.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] kernel-shark: Do not hardcode /usr prefix for polkit
 policies
In-Reply-To: <1aaeb84b-2820-0818-4ab6-fcfd7b5fa52c@gmail.com>
References: <87mtv97nlj.fsf@steelpick.2x.cz>
 <20210311145059.27147-1-michal.sojka@cvut.cz>
 <cf3243d3-65e0-18cd-0a20-81739552c105@gmail.com>
 <87k0qd7evn.fsf@steelpick.2x.cz>
 <1aaeb84b-2820-0818-4ab6-fcfd7b5fa52c@gmail.com>
Date:   Wed, 17 Mar 2021 13:59:38 +0100
Message-ID: <87lfam0wcl.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Yordan,

On Fri, Mar 12 2021, Yordan Karadzhov (VMware) wrote:
> If you are keen to try the latest version, checkout this one:
>
> https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/
>
> This is a brand new version that has a lot of changes under the hood and 
> needs user testing. We will be extremely happy to receive bug reports ;) 
> or patches for this new version.

Great! I've compiled this version and so far everything works. But I use
just basic features - opening the trace, searching and zooming.

On Fri, Mar 12 2021, Yordan Karadzhov (VMware) wrote:
> OK, now I see your problem. Please excuse my ignorance.
>
> Here's the deal. What you want can be achieved with an almost trivial 
> patch in kernelshark 2. Have a look here:
>
> https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/tree/src/CMakeLists.txt#n129
>
> and make the installation of the policy file to be a separate component.
> Make the installation of "kshark-su-record" part of the new component as 
> well since it relies on the policy file.

Sounds good. I'm working on the patch. I'll also send other changes that
will make my life easier.

> I guess "kernelshark.desktop" must be there as well.

I don't think so. Desktop files are looked for at multiple places,
including ~/.local/share/application or $XDG_<SOMETHING>.


-Michal
