Return-Path: <SRS0=x7pb=ZF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B76C43331
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Nov 2019 12:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 081B6222CD
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Nov 2019 12:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfKMM1i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 07:27:38 -0500
Received: from foss.arm.com ([217.140.110.172]:51654 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfKMM1i (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 07:27:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2383E7A7;
        Wed, 13 Nov 2019 04:27:38 -0800 (PST)
Received: from e120877-lin.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A739B3F6C4;
        Wed, 13 Nov 2019 04:27:37 -0800 (PST)
Date:   Wed, 13 Nov 2019 12:27:35 +0000
From:   Vincent Donnefort <vincent.donnefort@arm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Add an option to set saved_cmdlines_size
Message-ID: <20191113122735.GB318994@e120877-lin.cambridge.arm.com>
References: <1573123866-348262-1-git-send-email-vincent.donnefort@arm.com>
 <1573123866-348262-2-git-send-email-vincent.donnefort@arm.com>
 <20191111175203.252cc439@gandalf.local.home>
 <20191112120314.GA41032@e120877-lin.cambridge.arm.com>
 <20191112094037.651a156f@gandalf.local.home>
 <20191112190101.GA178419@e120877-lin.cambridge.arm.com>
 <20191112140920.6bbed145@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112140920.6bbed145@gandalf.local.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Nov 12, 2019 at 02:09:20PM -0500, Steven Rostedt wrote:
> On Tue, 12 Nov 2019 19:01:02 +0000
> Vincent Donnefort <vincent.donnefort@arm.com> wrote:
> 
> > This was not a good idea in the end. We can't rely on the sysctl entries
> > threads-max or pid_max, as the pid/comm map is static and the maximum is
> > defined by PID_MAX_DEFAULT. I do not see any way of getting this value from
> > user-space.
> > 
> > We could though, as an alternative, use a hard-coded value of 32768 for
> > --cmdlines-size. Without being perfect, this should still be true for most of
> > the systems. PID_MAX_DEFAULT depends on CONFIG_BASE_SMALL and hasn't changed
> > since Linux started using Git.
> 
> But that does take up a bit of memory in the kernel, which isn't
> probably needed. What we could do, is periodically record the contents
> of the file, and update the map at the end of the record.
> 
> Perhaps I should even make it so that we can just get notifications
> when it does get updated. But that would require a kernel change.
> 
> -- Steve

Hi Steve,

I then pushed an updated version covering your previous comments, small issues
and introducing the --cmdlines-size option without any default value.

Aside, apology for the disclaimer notice into the previous emails. This should
hopefully be gone by now.

-- 
Vincent
