Return-Path: <SRS0=D2WB=J3=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387714AbeGKOJT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Jul 2018 10:09:19 -0400
Date: Wed, 11 Jul 2018 10:04:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel-shark-qt: Fix the default value of the Event
 Visible flag
Message-ID: <20180711100447.05be89e6@gandalf.local.home>
In-Reply-To: <20180711133709.26788-2-y.karadz@gmail.com>
References: <20180711133709.26788-1-y.karadz@gmail.com>
        <20180711133709.26788-2-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 11 Jul 2018 16:37:09 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> This patch fixes a simpel bug in the way the "Event Visible" flag of the
> kshark_entries is set when the data is loadded.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---

Applied. Thanks Yordan!

-- Steve
