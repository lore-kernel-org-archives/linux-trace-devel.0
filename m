Return-Path: <SRS0=Hh4L=U2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75393C48BD9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 16:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55D42208E3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jun 2019 16:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfF0QPp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 12:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfF0QPp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 12:15:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D8520659;
        Thu, 27 Jun 2019 16:15:43 +0000 (UTC)
Date:   Thu, 27 Jun 2019 12:15:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Greg Thelen <gthelen@google.com>, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: remove ununsed knuth_hash*() routines
Message-ID: <20190627121542.2dc0d328@gandalf.local.home>
In-Reply-To: <550e11ae-1ac1-dbee-e88b-e62f63a6d032@gmail.com>
References: <20190626060101.220607-1-gthelen@google.com>
        <20190626153401.645b1174@gandalf.local.home>
        <550e11ae-1ac1-dbee-e88b-e62f63a6d032@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 27 Jun 2019 18:40:27 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> Hi Greg,
> 
> Thanks for the fix!
> 
> I agree that we have to remove the unused hashing functions, but may I 
> ask you to do a little bit of extra work here.
> I think that if we are going to keep only one hashing function this 
> function can be called simply knuth_has (not knuth_has8).

Hi Yordan,

Small nit. I think you meant "knuth_hash" not "knuth_has", even though
I'm sure knuth has a lot ;-)

> 
> Also the comment on top which refers to the TAOCP book must be modified 
> stating that the original idea from the book (32 bit hash) was adapted 
> in order to be used for small tables.

Ack.

-- Steve
