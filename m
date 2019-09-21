Return-Path: <SRS0=blxG=XR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.4 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96911C3A5A6
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 Sep 2019 04:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AC62208C2
	for <linux-trace-devel@archiver.kernel.org>; Sun, 22 Sep 2019 04:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfIVEWY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 22 Sep 2019 00:22:24 -0400
Received: from smtprelay0161.hostedemail.com ([216.40.44.161]:40186 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbfIVEWX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 22 Sep 2019 00:22:23 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Sep 2019 00:22:22 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 547161801DBD1;
        Sun, 22 Sep 2019 04:12:55 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 0E38F18029122;
        Sun, 22 Sep 2019 04:12:52 +0000 (UTC)
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-HE-Tag: wish09_530bb02a28129
X-Filterd-Recvd-Size: 2444
Received: from [10.102.230.9] (unknown [185.81.136.21])
        (Authenticated sender: rostedt@goodmis.org)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Sun, 22 Sep 2019 04:12:50 +0000 (UTC)
Date:   Sat, 21 Sep 2019 15:23:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20190921192108.GB8171@sasha-vm>
References: <20190919232359.825502403@goodmis.org> <20190921120618.DF81120665@mail.kernel.org> <20190921082035.4fc9ccc5@oasis.local.home> <20190921192108.GB8171@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [for-next][PATCH 3/8] tracing: Make sure variable reference alias has correct var_ref_idx
To:     Sasha Levin <sashal@kernel.org>
CC:     Tom Zanussi <zanussi@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        stable@vger.kernel.org
From:   Steven Rostedt <rostedt@goodmis.org>
Message-ID: <DF859F5E-4DBB-43C8-BD25-7E261240AE8C@goodmis.org>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On September 21, 2019 3:21:08 PM EDT, Sasha Levin <sashal@kernel.org> wrote:
>On Sat, Sep 21, 2019 at 08:20:35AM -0400, Steven Rostedt wrote:
>>On Sat, 21 Sep 2019 12:06:18 +0000
>>Sasha Levin <sashal@kernel.org> wrote:
>>
>>> Hi,
>>>
>>> [This is an automated email]
>>>
>>> This commit has been processed because it contains a "Fixes:" tag,
>>> fixing commit: .
>>>
>>> The bot has tested the following trees: v5.2.16, v4.19.74,
>v4.14.145, v4.9.193, v4.4.193.
>>
>>
>>The fixes tag is 7e8b88a30b085 which was added to mainline in 4.17.
>>According to this email, it applies fine to 5.2 and 4.19, but fails on
>>4.14 and earlier. As the commit was added in 4.17 that makes perfect
>>sense. Can you update your scripts to test when the fixes commit was
>>added, and not send spam about it not applying to stable trees where
>>it's not applicable.
>
>The script already does that. What happened here is that it got
>confused
>with your previous "Fixes:" statement in the commit message and went
>haywire.
>
>I thought that something like this shouldn't happen because I grep for
>"^fixes:", but looks like something is broken. I'll go fix that...


Thanks!

-- Steve

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity and top posting.
