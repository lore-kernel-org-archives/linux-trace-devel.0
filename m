Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7D7C54EBD
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 18:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbjAISGi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 13:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237670AbjAISGC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 13:06:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204723FC94
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 10:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4F31B80DDE
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 18:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145B3C433F2;
        Mon,  9 Jan 2023 18:05:40 +0000 (UTC)
Date:   Mon, 9 Jan 2023 13:05:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Khem Raj <raj.khem@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] Replace LFS64 interfaces off64_t and lseek64
Message-ID: <20230109130539.62a15985@gandalf.local.home>
In-Reply-To: <20230107010245.1290391-1-raj.khem@gmail.com>
References: <20230107010245.1290391-1-raj.khem@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  6 Jan 2023 17:02:45 -0800
Khem Raj <raj.khem@gmail.com> wrote:

> Musl does not define these interfaces unless -D_LARGEFILE64_SOURCE is
> defined and that too it is transitional until apps switch to using 64bit
> off_t. We pass -D_LARGEFILE64_SOURCE in makefiles already therefore
> original lseek and off_t are already 64bit

I just tested this, and that's not true.

static void pdie(const char *msg)
{
	perror(msg);
	exit(-1);
}

int main (int argc, char **argv)
{
	off_t off;
	int fd;

	argv0 = argv[0];

	if (argc < 2)
		usage();

	printf("off size = %zd\n", sizeof(off));

	fd = open(argv[1], O_RDONLY);
	if (fd < 0)
		pdie("open");
	off = lseek(fd, 0, SEEK_END);
	if (off < 0)
		pdie("lseek");
	printf("offset = %zd\n", off);
	return 0;
}

I compiled the above on a 32bit machine with:

$ gcc -D_LARGEFILE64_SOURCE -o lseek lseek.c
$ ./lseek big-file

Where big-file was 6GBs, and I got this:

off size = 4
lseek: Value too large for defined data type

The _LARGEFILE64_SOURCE just makes the 64 bit versions available. It does
not convert the original ones.

> 
> This fixes build with latest musl which has dropped LFS64 interfaces [1]
> 
> [1] https://git.musl-libc.org/cgit/musl/commit/?id=246f1c811448f37a44b41cd8df8d0ef9736d95f4i
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---

What we could do is add something like:

#ifdef MUSL
# define off64_t off_t
# define lseek64 lseek
[..]
#endif

in one of the headers to make it work with musl.

-- Steve
