Return-Path: <SRS0=a1Iv=2B=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359EAC43603
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 18:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B136A2077B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 11 Dec 2019 18:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=duncanthrax.net header.i=@duncanthrax.net header.b="UAJnnhxu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbfLKSOY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Dec 2019 13:14:24 -0500
Received: from shroom.duncanthrax.net ([178.63.180.169]:58509 "EHLO
        smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfLKSOY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Dec 2019 13:14:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=duncanthrax.net; s=dkim; h=In-Reply-To:Content-Type:MIME-Version:References
        :Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ufbZHwsY/9nj6K1GH7OdpYuqVG3d27/xnwT9bS0q0U0=; b=UAJnnhxu18P1B+mCOIIrbJSDHO
        eIXYMIr0ouG2va7ZlIq/mvnTm5CnUPS1PLOxYPnEvskHa19uvGPatW1CeaFtQlcxexCahExspfNmK
        d00sgO2mJgkBi3XpuOGPTz1G5860/POBndYi7rbEt1Std8kflVESaVEWgjuqErnvVZxE=;
Received: from hsi-kbw-046-005-233-221.hsi8.kabel-badenwuerttemberg.de ([46.5.233.221] helo=t470p.stackframe.org)
        by smtp.duncanthrax.net with esmtpa (Exim 4.90_1)
        (envelope-from <svens@stackframe.org>)
        id 1if6VB-0001QM-Ff; Wed, 11 Dec 2019 19:14:21 +0100
Date:   Wed, 11 Dec 2019 19:14:21 +0100
From:   Sven Schnelle <svens@stackframe.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <zanussi@kernel.org>
Subject: Re: ftrace histogram sorting broken on BE architecures
Message-ID: <20191211181421.GA19097@t470p.stackframe.org>
References: <20191211123316.GD12147@stackframe.org>
 <20191211103557.7bed6928@gandalf.local.home>
 <20191211110959.2baeb70f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211110959.2baeb70f@gandalf.local.home>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

On Wed, Dec 11, 2019 at 11:09:59AM -0500, Steven Rostedt wrote:
> On Wed, 11 Dec 2019 10:35:57 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > Any thoughts on how to fix this? I'm not sure whether i fully understand the
> > > ftrace maps... ;-)  
> > 
> > Your analysis makes sense. I'll take a deeper look at it.
> 
> Does this patch fix it for you?

Yes, it does. Thanks for looking into this.

> Correct me if I'm wrong, from what I can tell, all sums and keys are
> u64 unless they are a string. Thus, I believe this patch should not
> have any issues.

I'll retest if Tom comes up with another patch.

Thanks,
Sven
