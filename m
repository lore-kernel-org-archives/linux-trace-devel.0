Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40419 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933684AbeAJISF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 03:18:05 -0500
Received: by mail-wr0-f193.google.com with SMTP id 100so585132wrb.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Jan 2018 00:18:04 -0800 (PST)
Message-ID: <1515572248.24761.5.camel@gmail.com>
Subject: Re: [PATCH] trace-cmd TAGS: Fix tags to not parse .pc directory of
 patch
From: Vladislav Valtchev <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Date: Wed, 10 Jan 2018 10:17:28 +0200
In-Reply-To: <20180110014754.61598eaa@vmware.local.home>
References: <20180110014754.61598eaa@vmware.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 2018-01-10 at 01:47 -0500, Steven Rostedt wrote:
> [ Vlad, this patch does touch the Makefile. How will it affect you? ]
> 

Thanks for asking, Steven.

I've applied this patch on a temp_master branch and I've tried to rebase
all of my makefile-related changes on the top of it. Fortunately we're lucky
and git's 3-way merge was able to correctly rebase everything. I've quickly
tested that the build (both in-tree and out-of-tree) continue to work.

In conclusion, no problem with this patch at all :-)

-- 
Vladislav Valtchev
VMware Open Source Technology Center
