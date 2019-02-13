Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1EEC282C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 14:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B89462190A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 14:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfBMOl7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:41:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730035AbfBMOl7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 09:41:59 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B55520835;
        Wed, 13 Feb 2019 14:41:58 +0000 (UTC)
Date:   Wed, 13 Feb 2019 09:41:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/5] The right click of the button deselects the marker
Message-ID: <20190213094157.35667a81@gandalf.local.home>
In-Reply-To: <20190212170402.10104-1-ykaradzhov@vmware.com>
References: <20190212170402.10104-1-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 12 Feb 2019 19:03:57 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> This series of patches implements the feature requested in
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202327
> 
> 
> Yordan Karadzhov (5):
>   kernel-shark: Customize the marker switching button
>   kernel-shark: Define a method in View for selecting the Passive marker
>   kernel-shark: Define KS_NO_ROW_SELECTED as a negative row index (-1)
>   kernel-shark-qt: Do marker-deselect by right mouse click of the button
>   kernel-shark: Rename the method for deselecting the Active marker.
> 
>  kernel-shark/src/KsDualMarker.cpp  | 21 ++++++++++++++
>  kernel-shark/src/KsDualMarker.hpp  | 46 ++++++++++++++++++++++++++++--
>  kernel-shark/src/KsMainWindow.cpp  | 38 +++++++++++++++++++++---
>  kernel-shark/src/KsMainWindow.hpp  |  6 +++-
>  kernel-shark/src/KsModels.cpp      |  8 +++---
>  kernel-shark/src/KsModels.hpp      |  3 ++
>  kernel-shark/src/KsTraceViewer.cpp | 22 ++++++++++++--
>  kernel-shark/src/KsTraceViewer.hpp |  2 ++
>  8 files changed, 132 insertions(+), 14 deletions(-)
> 

Applied. Thanks a lot Yordan!

-- Steve
