Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F1BC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 13:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 435E42146F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 13:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfC0NHQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 09:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbfC0NHQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 09:07:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7592C206DF;
        Wed, 27 Mar 2019 13:07:15 +0000 (UTC)
Date:   Wed, 27 Mar 2019 09:07:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Message-ID: <20190327090714.6ab0e534@gandalf.local.home>
In-Reply-To: <6424edde-820e-a6a0-ac4e-cacf8c225652@vmware.com>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
        <20190313152220.22026-3-ykaradzhov@vmware.com>
        <20190326165125.5537384d@gandalf.local.home>
        <6424edde-820e-a6a0-ac4e-cacf8c225652@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 27 Mar 2019 08:58:20 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> Yes, this makes sense. I will make the application creating the 
> .cache/kernelshark directory if it doesn't exist.
> 
> But do I need to remove the creation of directory in the build process?

Yes, please remove it. A build process shouldn't modify directories
outside the build directory unless specifically told to do so (like
make install).

-- Steve
