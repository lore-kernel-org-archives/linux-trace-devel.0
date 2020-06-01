Return-Path: <SRS0=rFKH=7O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270D8C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jun 2020 16:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E09D520734
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jun 2020 16:45:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="ul4+lTRZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFAQpL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Jun 2020 12:45:11 -0400
Received: from mail.efficios.com ([167.114.26.124]:56834 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFAQpL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Jun 2020 12:45:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id A4F042950F9
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2020 12:45:10 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id AyzDeFVLq290 for <linux-trace-devel@vger.kernel.org>;
        Mon,  1 Jun 2020 12:45:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 734492950F7
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2020 12:45:10 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 734492950F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1591029910;
        bh=l0kBSVXkqNH8BZ4HHdfGXrDL6WctIYXHD60Rf4Spcc4=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=ul4+lTRZJMcLRSqnfflzu1r+9tNWslYBKX1nozNeVuZ4qfbXUAW/jTSAvjzVrxKuk
         r2EcRe1npTIFHELDMPcry+yIObHpxeX/si/Wm/yuTAexFSywn5pV+8nZvBPpLMOA2V
         MPEOEUEXXWV5MlASAZmjVX8RR3EebDwIn2gO8iJoJ7ZocPb3IsB0Mt8nOW2tCesBtw
         cAjFXHi4HmJsstj/hh4MLhrFdumv6Jl2dUZ6icXkc/ok+LgJiF1qMVJeqYTzdY0Va1
         Vchuigm+goNh1FFhZRqCXzbMatX+L0jTer7aICXbl2kOc5RQLKZ1+sJx4aFwWVC+Lo
         eSCj0Yw1RN4fQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tSl9sXzBxvhs for <linux-trace-devel@vger.kernel.org>;
        Mon,  1 Jun 2020 12:45:10 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 6B80C2950F6
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Jun 2020 12:45:10 -0400 (EDT)
Date:   Mon, 1 Jun 2020 12:45:10 -0400 (EDT)
From:   Philippe Duplessis-Guindon <pduplessis@efficios.com>
To:     linux-trace-devel <linux-trace-devel@vger.kernel.org>
Message-ID: <2053437111.45156.1591029910431.JavaMail.zimbra@efficios.com>
Subject: Ftrace plugin for Babeltrace2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3928 (ZimbraWebClient - FF76 (Linux)/8.8.15_GA_3928)
Thread-Index: 4hBBt5IM0JHT39y/evg4q7qQX+EQNg==
Thread-Topic: Ftrace plugin for Babeltrace2
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi everyone,


My name is Philippe and I am an intern at EfficiOs for the summer. This email is

to inform you about my summer project, ask for recommendations and your opinion.


My project will consist of implementing a Babeltrace2 [1] plugin to be able to consume

ftrace traces. The plugin will act as a source component in the babeltrace2 graph system.


I was wondering if you can give me your first thoughts about this project, and

any advice on where to find information to begin with, since I am new to ftrace.

I have already read the doc [2][3][4], but I was wondering if there are more resources

that could help me with my work.


Also, I was wondering which version of libtraceevent I should use. The one in the kernel,

or the one in the trace-cmd repo? My guess would be to take the one in trace-cmd since

there are more recent commits, but I am asking just to make sure.


The major focus of the project will be to match ftrace concepts to babeltrace 2

internal representation.


[1] https://babeltrace.org/

[2] https://github.com/torvalds/linux/tree/master/tools/lib/traceevent/Documentation

[3] https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/tree/Documentation

[4] https://www.kernel.org/doc/Documentation/trace/ftrace.txt


Thank you,

Philippe
