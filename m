Return-Path: <SRS0=Ut0o=MA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:46736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729037AbeIRWvQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Sep 2018 18:51:16 -0400
Date: Tue, 18 Sep 2018 13:17:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kernel-shark-qt: Add "DEBUG" build mode.
Message-ID: <20180918131741.105ddaba@gandalf.local.home>
In-Reply-To: <20180918170832.7865-1-y.karadz@gmail.com>
References: <20180918170832.7865-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 18 Sep 2018 20:08:31 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> "-g" compiler option is added to both C and C++ compiler flags, allowing
> debug information to be generated. If the DEBUG Command-Line option is not
> provided or is set to zero, the "-O2" compiler flag is added as well.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

Looks good, I accepted both patches.

Thanks Yordan!

-- Steve
