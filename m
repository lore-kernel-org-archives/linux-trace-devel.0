Return-Path: <SRS0=8rzQ=JG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754579AbeFTSNU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jun 2018 14:13:20 -0400
Date: Wed, 20 Jun 2018 14:13:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] trace-filter: Change the hashing function used
 when filtering
Message-ID: <20180620141318.3381f6dc@gandalf.local.home>
In-Reply-To: <129b43b8-e526-b8b7-f581-144fd82d2dd1@Gmail.com>
References: <20180619132259.21387-1-y.karadz@gmail.com>
        <20180619132259.21387-2-y.karadz@gmail.com>
        <20180620112113.67dbdb4f@gandalf.local.home>
        <129b43b8-e526-b8b7-f581-144fd82d2dd1@Gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 20 Jun 2018 21:04:48 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> My only reason for having the hash functions in the header is to make sure
> that the user will be aware that those are cheap and fast functions, but 
> using
> those functions makes sense only in the case when we have relatively small
> number of items in the hash table. Nevertheless, If you prefer the 
> implementation
> to be in the .c file this is OK.

Either that, or in a local header file. I don't think we need to export
this as part of libtracecmd.a

I'll make the changes.

Thanks!

-- Steve
