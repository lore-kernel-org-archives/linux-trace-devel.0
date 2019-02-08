Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58F7C169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 19:34:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB8512177B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 19:34:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfBHTed (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 14:34:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbfBHTed (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 14:34:33 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4463820855;
        Fri,  8 Feb 2019 19:34:32 +0000 (UTC)
Date:   Fri, 8 Feb 2019 14:34:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: Re: [PATCH 6/8] trace-cmd: Make tracecmd_msg_send_close return
 error code if any
Message-ID: <20190208143430.589f101b@gandalf.local.home>
In-Reply-To: <20190205101449.6d7ed6d2@gandalf.local.home>
References: <20190204070855.8921-1-kaslevs@vmware.com>
        <20190204070855.8921-7-kaslevs@vmware.com>
        <20190205101449.6d7ed6d2@gandalf.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 5 Feb 2019 10:14:49 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon,  4 Feb 2019 09:08:53 +0200
> Slavomir Kaslev <kaslevs@vmware.com> wrote:
> 
> I accepted your patches up to here with some slight modifications to
> the subjects and change logs. Note, when referencing function names,
> its mostly desirable to add a "()" to the end of them to make it stand
> out that they are functions. Like tracecmd_msg_send_close().
> 
> But, this patch needs a change log to explain why this function should
> return an error code. Is something going to rely on it in the future?
> 

I think I'll take this patch anyway (and add a change log to it). Since
it can fail, it would be good to return the error.

-- Steve
