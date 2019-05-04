Return-Path: <SRS0=6G4v=TE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC06AC43219
	for <linux-trace-devel@archiver.kernel.org>; Sat,  4 May 2019 11:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B27E8206DF
	for <linux-trace-devel@archiver.kernel.org>; Sat,  4 May 2019 11:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfEDLhL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 4 May 2019 07:37:11 -0400
Received: from smtprelay0089.hostedemail.com ([216.40.44.89]:43528 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726529AbfEDLhL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 4 May 2019 07:37:11 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 May 2019 07:37:10 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id 845821800173C
        for <linux-trace-devel@vger.kernel.org>; Sat,  4 May 2019 11:31:15 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 9E3541802926E;
        Sat,  4 May 2019 11:31:14 +0000 (UTC)
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-HE-Tag: war73_44fb1bc5c751e
X-Filterd-Recvd-Size: 1497
Received: from [192.168.4.174] (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (Authenticated sender: rostedt@goodmis.org)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Sat,  4 May 2019 11:31:13 +0000 (UTC)
Date:   Sat, 04 May 2019 07:31:12 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <00b42af8-c822-82ea-76bd-afe6fe277644@gmail.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com> <20190502124009.32208-4-ykaradzhov@vmware.com> <20190503190557.6e36e59a@gandalf.local.home> <00b42af8-c822-82ea-76bd-afe6fe277644@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH v2 3/8] kernel-shark: Add logic for the plugins search path
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
CC:     linux-trace-devel@vger.kernel.org, troyengel@gmail.com,
        Slavomir Kaslev <kaslevs@vmware.com>
From:   Steven Rostedt <rostedt@goodmis.org>
Message-ID: <4FEC5D87-2562-48C6-81AA-471184DE092D@goodmis.org>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On May 4, 2019 4:27:47 AM EDT, "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
>
>I see the problem. Have you pushed this patch already? I can send you a
>
>corrected version of the patch or a separate patch with the fix.
>


I have not pushed yet. Please send a new version of this patch.

Thanks,

-- Steve


-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity and top posting.
