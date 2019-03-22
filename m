Return-Path: <SRS0=pKOM=RZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43DDC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA793218FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Mar 2019 15:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfCVPZp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Mar 2019 11:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbfCVPZp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Mar 2019 11:25:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 394A32083D;
        Fri, 22 Mar 2019 15:25:44 +0000 (UTC)
Date:   Fri, 22 Mar 2019 11:25:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [PATCH] trace-cmd: Change tracecmd_msg's buf member type to
 char *
Message-ID: <20190322112542.0bf2e37d@gandalf.local.home>
In-Reply-To: <20190322150105.24136-1-kaslevs@vmware.com>
References: <20190322150105.24136-1-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Mar 2019 17:01:05 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Now that the buffer for protocol V3 messages is always text, it makes sense to
> have it declared as such and drop a few casts.

Is it always text?

When debugging the listener I saw the meta data sent as non text.

 tracecmd_msg_data_send()

Sends the data in binary, not text. Which is what we want.

-- Steve


> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
