Return-Path: <SRS0=wZju=UE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25083C28CC5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jun 2019 13:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05A3120866
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jun 2019 13:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbfFENOy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 09:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727601AbfFENOy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 09:14:54 -0400
Received: from oasis.local.home (unknown [146.247.46.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BCA62075C;
        Wed,  5 Jun 2019 13:14:53 +0000 (UTC)
Date:   Wed, 5 Jun 2019 09:14:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/2] To be included in KS 1.0
Message-ID: <20190605091448.792d0043@oasis.local.home>
In-Reply-To: <20190530131330.21701-1-ykaradzhov@vmware.com>
References: <20190530131330.21701-1-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 30 May 2019 16:13:28 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The patch-set contains modifications motivated by the attempt to
> implement a standalone version of the NumPy data interface. Those
> changes do improve the code but strictly speaking are not compulsory
> for KS 1.0. Nevertheless, I would prefer to get those patches upstream
> a.s.a.p. Versions of the two patches have been send already several
> times as part of different other patch-sets.
> 
> Yordan Karadzhov (2):
>   kernel-shark: Add new dataloading method to be used by the NumPu
>     interface
>   kernel-shark: Use full paths for non-standard library headers

Looks good!

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

> 
>  include/trace-cmd/trace-cmd.h         |   2 +-
>  include/traceevent/event-parse.h      |   2 +-
>  kernel-shark/CMakeLists.txt           |   3 +-
>  kernel-shark/build/FindTraceCmd.cmake |  44 ++++----
>  kernel-shark/src/libkshark-plugin.h   |   2 +-
>  kernel-shark/src/libkshark.c          | 139 ++++++++++++++++++++++++++
>  kernel-shark/src/libkshark.h          |  16 ++-
>  7 files changed, 172 insertions(+), 36 deletions(-)
> 

