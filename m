Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F65C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 16:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359018AbhLFQbQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 11:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387870AbhLFQbJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 11:31:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC1BC061354
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 08:27:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80F61B8111E
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 16:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A84C341C6;
        Mon,  6 Dec 2021 16:27:37 +0000 (UTC)
Date:   Mon, 6 Dec 2021 11:27:36 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5 04/25] trace-cmd library: Add internal helper
 function for writing headers before file sections
Message-ID: <20211206112736.137c30be@gandalf.local.home>
In-Reply-To: <CAPpZLN4MznQUGc-yn6Cebt5FdONcwsAR48ySt9S_XJ594XULqw@mail.gmail.com>
References: <20211111150900.86585-1-tz.stoyanov@gmail.com>
        <20211203203553.5bc05010@gandalf.local.home>
        <CAPpZLN77x4P=p=DKvj4NMvv4LvVTpcfepFMbc_a-EwBzTkrWGQ@mail.gmail.com>
        <20211206095531.55f8b0b8@gandalf.local.home>
        <CAPpZLN4MznQUGc-yn6Cebt5FdONcwsAR48ySt9S_XJ594XULqw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 6 Dec 2021 17:52:54 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> As we discussed, there are two possible approaches for these descriptions:
>  1. To add a new section with these descriptions, that way there will
> be no strings in the section headers. I was thinking more about that
> approach, it will make the parsing much more complicated. As all
> sections are dynamically located in the file, there is no strict order
> - that "description" section can be anywhere, even at the end. That
> way during the parsing these strings will not be available for the
> sections before, and the description cannot be displayed. To solve
> that, parsing should be done in two steps -  first to find that
> "description" section to get all the strings, and second to parse the
> other sections. The description should be part of the section being
> parsed, that's why I decided to go with the second approach.

Again, I would look at the ELF file format for answers ;-)

The "string table" is a special section that is described in the main
header. That way, the first thing it does, is to to look for this table. It
scans all the section headers to find the one that points to the strings,
and then loads that one first.

For string "pointers", the pointer is not an offset into the file, but an
offset into the section (uncompressed). So for reading the file, yes, we
would need to first find the string section, and load all the strings into
memory. Then go back and read the normal sections. Then we have access for
all the strings. I would also say that the string section is optional, and
a file could be created with no strings, as they are for description
purposes only, and in that case, we need to just say "no strings found" for
anything that wants to know the string.

-- Steve

> 2. Have a fixed size description string in the section header, I think
> 32 bytes should be OK.

