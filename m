Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B2BC282E2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:19:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 465B82190A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbfDSSTP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfDSSTO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:19:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CBFA2190A;
        Fri, 19 Apr 2019 18:13:29 +0000 (UTC)
Date:   Fri, 19 Apr 2019 14:13:28 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: Re: [PATCH v3 0/8] Various modifications and fixes toward KS 1.0
Message-ID: <20190419141328.68d7f0aa@gandalf.local.home>
In-Reply-To: <20190419135036.19340-1-ykaradzhov@vmware.com>
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Apr 2019 16:50:28 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The patch-set contains reimplementation of patches that have been sent
> already, but have been found to have various problems. The last two
> patch are fixes of bugs that have been found recently.
> 
> Changes in v3:
>  - Corrections from Slavomir (in patches 1/8 and 3/8)
> 
> Yordan Karadzhov (8):
>   kernel-shark: Configuration information in ${HOME}/.cache/kernelshark
>   kernel-shark: Remove the definition of KS_CONF_DIR
>   kernel-shark: Add logic for the initial path of Open-File dialogs
>   kernel-shark: Add logic for the plugins search path
>   kernel-shark: Rename KS_DIR to KS_SOURCE_DIR
>   kernel-shark: Load Last Session from command line
>   kernel-shark: Use proper searching condition when the dataset is small
>   kernel-shark: Handle the case when the marker points to a filtered
>     entry

I applied patches:

 1, 2 and 7

-- Steve
