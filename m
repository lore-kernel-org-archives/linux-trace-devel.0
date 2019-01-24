Return-Path: <SRS0=xzjd=QA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF54C282C2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jan 2019 00:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3932218A2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Jan 2019 00:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfAXA1x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 23 Jan 2019 19:27:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfAXA1x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 23 Jan 2019 19:27:53 -0500
Received: from vmware.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C551B217D7;
        Thu, 24 Jan 2019 00:27:51 +0000 (UTC)
Date:   Wed, 23 Jan 2019 19:27:42 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-trace-devel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH v2] trace-cmd: make python work again
Message-ID: <20190123192742.12b7fc2c@vmware.local.home>
In-Reply-To: <20190123132627.7619-1-johannes@sipsolutions.net>
References: <20190123132627.7619-1-johannes@sipsolutions.net>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 23 Jan 2019 14:26:27 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Code reshuffling/renaming wasn't complete in ctracecmd.i:
>  * it needs to %include "trace-seq.h" so that we
>    can access those functions from python
>  * it needs to use tep_* instead of pevent_* everywhere,
>    even function calls done as parameters to functions,
>    I guess some sort of automatic conversion missed those
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>

Applied.

Thanks Johannes!

-- Steve
