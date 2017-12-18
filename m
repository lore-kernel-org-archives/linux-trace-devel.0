Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail-wr0-f195.google.com ([209.85.128.195]:43617 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbdLRP3R (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 10:29:17 -0500
Received: by mail-wr0-f195.google.com with SMTP id w68so2013920wrc.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Dec 2017 07:29:17 -0800 (PST)
Message-ID: <1513610954.2904.1.camel@gmail.com>
Subject: Re: [RFC PATCH v3 4/9] trace-cmd: Extract part of Makefile in
 utils.mk
From: Vladislav Valtchev <vladislav.valtchev@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Date: Mon, 18 Dec 2017 17:29:14 +0200
In-Reply-To: <20171213104704.77a77f9c@gandalf.local.home>
References: <20171212162534.31144-1-vladislav.valtchev@gmail.com>
         <20171212162534.31144-5-vladislav.valtchev@gmail.com>
         <20171212190037.53710fa2@gandalf.local.home>
         <1513171955.2565.42.camel@gmail.com>
         <20171213104704.77a77f9c@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 2017-12-13 at 10:47 -0500, Steven Rostedt wrote:
> 
> I'm just following what we do in the Linux kernel. It has a directory
> called "scripts" to help with the build process. As trace-cmd is very
> tied to the Linux kernel, I want to keep as close to it as possible.
> Hence, why we are doing all this crazy stuff with make and not any
> other tool.
> 

Alright. I've already done the change utils.mk -> scripts/utils.mk in my repo.
