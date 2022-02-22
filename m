Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE378C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 17:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbiBVRvQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 12:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbiBVRvP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 12:51:15 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F374167F99
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 09:50:48 -0800 (PST)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id 55ADC20C31B0;
        Tue, 22 Feb 2022 09:50:48 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 55ADC20C31B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1645552248;
        bh=Qm/5li4KlASFlfAkUb9H7wziTo4T8Svayn9cm1AUgSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mhK9txvE5dsolLZize/jpynrA2dxe37u/6cbRE1NTWJmWfTrK6eP7ypwhwludSSq3
         w3tGENbjFsUJtC0fmK/2F8P4Y2GIsLailvRUG7YONxRK9cFNmRyyL0OrC/I7Km3fwN
         YAknh38ehsC5hwgr6FX0yh5NuXsKYi33F7Iqx5Xk=
Date:   Tue, 22 Feb 2022 09:50:45 -0800
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] libtracefs: Add APIs for user_events to libtracefs
Message-ID: <20220222175045.GC1709@kbox>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
 <20220222123447.244b8f57@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222123447.244b8f57@gandalf.local.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 12:34:47PM -0500, Steven Rostedt wrote:
> On Fri, 18 Feb 2022 14:50:55 -0800
> Beau Belgrave <beaub@linux.microsoft.com> wrote:
> 
> > New APIs added:
> 
> Beau,
> 
> I'm not sure what you work load is, but if you can get out a v2 today (or
> tomorrow), that would be great. I want to release libtracefs 1.3 in the
> next couple of days, and I'm only holding it off to include these APIs.
> 

Yeah, I can get a v2 today I think. We keep expanding what to change in
the thread (which is great) so I'll do my best to capture it all out in
the v2. I plan to start in a few hours, with what we've talked about so
far.

Thanks,
-Beau
