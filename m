Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD09C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:23:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 859DF20880
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 13:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfDINXv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:41882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbfDINXv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 09:23:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 743312084C;
        Tue,  9 Apr 2019 13:23:50 +0000 (UTC)
Date:   Tue, 9 Apr 2019 09:23:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Slavomir Kaslev <kaslevs@vmware.com>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Message-ID: <20190409092349.3e7cb6e3@gandalf.local.home>
In-Reply-To: <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
        <20190404145603.13592-2-ykaradzhov@vmware.com>
        <20190408150102.GA6430@box>
        <20190408111308.301f30c1@gandalf.local.home>
        <0808d774-880a-f232-dda3-cd897120d86d@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 9 Apr 2019 15:23:56 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> I can make the GUI to check if _KS_CACHE_DIR is defined and if its value 
> (path) belongs to the user who runs the GUI. If this is not the case, 
> The GUI will use the default location (~/cache/kernelshark).

Can't we just make it so that it always does this path?

-- Steve
