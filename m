Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F7AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Apr 2022 14:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353444AbiDSOic (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Apr 2022 10:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353415AbiDSOib (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Apr 2022 10:38:31 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C32C20182;
        Tue, 19 Apr 2022 07:35:47 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 4BFCF3C56FF;
        Tue, 19 Apr 2022 10:35:46 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id R-VnQ2zxcchr; Tue, 19 Apr 2022 10:35:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A522F3C53DD;
        Tue, 19 Apr 2022 10:35:45 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com A522F3C53DD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1650378945;
        bh=633pQxxAWd4+mVGElSVB2wU4Sye2IG1UF5utL7p1Dgc=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=R3sE6GhItWuYLql2uY0aAmuhV+/PQ9OW2IiW5iv3B9ErZm2vXI0CE83vlPXsmRpts
         Pn49ntvqG+jlIK9iVxp0csKdQy+AK0lyskyeBvAKPefIp59JIZXc37weBZbeIssSAs
         izuwiMeBFGbSClXT1xNkAUbGQ7mSzNQuOTRCvoED3yqAOh2O9FsSD1XZ5atKJyx6JY
         v6llS0In4AglWGW/4MRkLGJmMCzsoofaSRTvuBbFPLCJ4vlj4elKmu9HWycYR5KS+a
         MONTULd35JDGz0dVWjEByWsZBaIar90weJPqi9O0+QFlJb9SZ2M6Q97xgF9PGpWpjy
         U/o0QciyKc+6w==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CLySuEcIvIqG; Tue, 19 Apr 2022 10:35:45 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 98BDD3C5747;
        Tue, 19 Apr 2022 10:35:45 -0400 (EDT)
Date:   Tue, 19 Apr 2022 10:35:45 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Message-ID: <337584634.26921.1650378945485.JavaMail.zimbra@efficios.com>
In-Reply-To: <20220401234309.21252-7-beaub@linux.microsoft.com>
References: <20220401234309.21252-1-beaub@linux.microsoft.com> <20220401234309.21252-7-beaub@linux.microsoft.com>
Subject: Re: [PATCH 6/7] tracing/user_events: Use bits vs bytes for enabled
 status page data
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4257 (ZimbraWebClient - FF99 (Linux)/8.8.15_GA_4257)
Thread-Topic: tracing/user_events: Use bits vs bytes for enabled status page data
Thread-Index: 3mhe0Mcep7c7n2Jzj66zR4QLGQO38A==
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

----- On Apr 1, 2022, at 7:43 PM, Beau Belgrave beaub@linux.microsoft.com wrote:

> User processes may require many events and when they do the cache
> performance of a byte index status check is less ideal than a bit index.
> The previous event limit per-page was 4096, the new limit is 32,768.
> 
> This change adds a mask property to the user_reg struct. Programs check
> that the byte at status_index has a bit set by ANDing the status_mask.
> 
> Link:
> https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/
> 
> Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>

Hi Beau,

Considering this will be used in a fast-path, why choose bytewise
loads for the byte at status_index and the status_mask ?

I'm concerned about the performance penalty associated with partial
register stalls when working with bytewise ALU operations rather than
operations using the entire registers.

Ideally I would be tempted to use "unsigned long" type (32-bit on 32-bit
binaries and 64-bit on 64-bit binaries) for both the array access
and the status mask, but this brings extra complexity for 32-bit compat
handling.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
