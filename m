Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FD7C282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF95F222EB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfDSSS4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbfDSSSz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:18:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D120222E9;
        Fri, 19 Apr 2019 18:18:54 +0000 (UTC)
Date:   Fri, 19 Apr 2019 14:18:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: Re: [PATCH v2 1/8] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Message-ID: <20190419141852.51c98960@gandalf.local.home>
In-Reply-To: <CAE0o1NtWOkUWvmsc+RtJjM8LdD1Fp8C8wEir-WPj2GCxUhz+8Q@mail.gmail.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
        <20190418152146.27232-2-ykaradzhov@vmware.com>
        <CAE0o1NtWOkUWvmsc+RtJjM8LdD1Fp8C8wEir-WPj2GCxUhz+8Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Apr 2019 10:19:38 +0300
Slavomir Kaslev <slavomir.kaslev@gmail.com> wrote:

> Nit: s/QString(getpwuid(getuid())->pw_dir)/QDir::homePath()/
> 
> Everything else looks great with the patch
> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Yordan,

If someone gives you a review by, please add it to the next revision, if
you didn't change the patch. And if you do change it, ask for a new
review-by.

Thanks!

-- Steve
