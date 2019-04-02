Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E853CC10F0B
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B84BB20856
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="okSYdnut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732050AbfDBNox (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:44:53 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:53095 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732020AbfDBNow (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:44:52 -0400
Received: by mail-it1-f193.google.com with SMTP id x132so3103416itf.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2RoX67Lr3VInMZ9vQnbn7/mwQeklKvPKN0jgKaiHBr4=;
        b=okSYdnutoQhMGmGy3461vDqaXpTwbjFdRJpIsBh89SeCug3+Wm/UWrmUGAIApw7AP1
         aCWPExrsOrSQKh5EKYLdLmZ8/Lq8rESPbuvjSIscOHOyLpp3/zbE6LfapEWcwXqRX/IE
         +QBgBwgjGvkmO10eeIaSewVMU8GLtA8gQ54E113KRWWa0sK6yrpR6m0ak25j35zSqs80
         j8jyVA6LO5mf+mkulBBsqVWNPnSa25H8ucOI6sj5OX6Vq8/fx7/xpsqDvvVNSqwiZSaq
         IieGEaAa1W0NHmYYZxqC8tpvtFxQFwHSSvWDWuJfmVOe/2K/jpDTYu9UVsRqC9QGdrWd
         3EvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2RoX67Lr3VInMZ9vQnbn7/mwQeklKvPKN0jgKaiHBr4=;
        b=aAz2mwW28sW9eMEyZ/L1iVcrpYFU/xrdfw4o2s0eLcH7PDTfyC0pedl/XBh2GC/yqj
         CHoZFyDcRqrMHKXvlc2PDyJWHzTrnfMjCywyv51GiwR9duGopJE8mNQk4dLJtEOdIADb
         miUXPsAjmW9bGGFv61EL5Qr0S7ldxLNuqa8ca2KwmoBNQaJhv5nor0ZSsUNDChYZIPY1
         Wlczq6lMr7XjVBs828zK5tkrE5kzVHeAUcrnB7uiI+IyW8GEWc8n9l8wSA2I+qyEqUEH
         nJmPF/oNvM9ha2Ug8Bnqb3/8wEJU7pXLOZrWv4o8eIVDa6Rkk5TZbwMnE1SsVRcx1kFq
         3rNw==
X-Gm-Message-State: APjAAAWD0Q0vGeDCJWkG9C8b/rQRyWjRH3vdKWTVW+4euogqicYKtHLr
        3c3FBK7IfRQcZ9WStUVHPV4lng83D0/AhrvlY62mRdQ=
X-Google-Smtp-Source: APXvYqwMNQ7xaYSm0F5FFJ7IAuusD7c6GfyEmPMAU/THT8DC+9+YCrG2GUa6KynXDGcMWaXzv+yZZdxSfK6V3fmUV24=
X-Received: by 2002:a24:2a88:: with SMTP id w130mr3998147itw.95.1554212691104;
 Tue, 02 Apr 2019 06:44:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190402134230.30988-1-kaslevs@vmware.com>
In-Reply-To: <20190402134230.30988-1-kaslevs@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Tue, 2 Apr 2019 16:44:40 +0300
Message-ID: <CAE0o1NtscNwft6Uyt9Kaid_=0H8Z-1XrYDfLzAHh02jHj8zRQg@mail.gmail.com>
Subject: Re: [RFC PATCH v8 00/11] Add VM kernel tracing over vsockets and FIFOs
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Please ignore this thread. I'll resent as v9.

On Tue, Apr 2, 2019 at 4:42 PM Slavomir Kaslev <kaslevs@vmware.com> wrote:
>
> This patchset adds support for tracing guest kernels to trace-cmd.
>
> Changes in v8:
>  - switched protocol message encoding of ports to text
>  - switched ports data type to unsigned since vsockets port numbers can overflow int and be confused with errors codes by other code
>  - added automatic naming for guests with no names (for VMware Workstation guests currently)
>  - added --debug option to trace-cmd agent
>
> Changes in v7:
>  - fixed potential memory leak in add_arg()
>  - call msg_free() in tracecmd_msg_recv_trace_req() eventhough we're stealing
>    the message buffer
>  - added is_guest and is_agent macros and use throughout tracecmd_record.c
>    instead of testing instance->flags bits
>  - avoid memory allocation in make_dir()
>
> Changes in v6:
>  - added specialized data transfer path over FIFOs making single splice() per
>    iteration
>  - made tracecmd_msg_recv_trace_req/tracecmd_msg_recv_trace_resp more defensive
>    to invalid messages
>
> Changes in v5:
>  - add FIFOs transport for tracing data
>  - fixed a bug in tracecmd_msg_wait_close
>
> Changes in v4:
>  - detect and use splice(2) on vsock sockets if possible
>  - switch port numbers to unsigned int
>  - trace-cmd record --date flag is now set for all guests if provided by the user
>  - removed grow_cap and exponential buffer size growth
>
> Changes in v3:
>  - addressed Steven's feedback
>  - detect and disable guest tracing if <linux/vm_sockets.h> is not available
>  - the --date flag is now treated as global for all guest instances
>  - fixed a bug that caused --date to be ignored for host tracing data when tracing guests
>
> Changes in v2:
>  - rebased on top of protocol V3
>  - fixed system clock timestamps with the --date flag
>
> Slavomir Kaslev (10):
>   trace-cmd: Make ports unsigned int
>   trace-cmd: Add tracecmd_create_recorder_virt function
>   trace-cmd: Add TRACE_REQ and TRACE_RESP messages
>   trace-cmd: Add buffer instance flags for tracing in guest and agent
>     context
>   trace-cmd: Add VM kernel tracing over vsockets transport
>   trace-cmd: Use splice(2) for vsockets if available
>   trace-cmd: Add `trace-cmd setup-guest` command
>   trace-cmd: Try to autodetect number of guest CPUs in setup-guest if
>     not specified
>   trace-cmd: Add setup-guest flag for attaching FIFOs to the guest VM
>     config
>   trace-cmd: Add splice() recording from FIFO without additional pipe
>     buffer
>
> Steven Rostedt (VMware) (1):
>   trace-cmd: Detect if vsockets are available
>
>  Makefile                       |   7 +
>  include/trace-cmd/trace-cmd.h  |  18 +-
>  lib/trace-cmd/trace-recorder.c | 129 ++++--
>  tracecmd/Makefile              |   5 +
>  tracecmd/include/trace-local.h |  29 ++
>  tracecmd/trace-agent.c         | 294 +++++++++++++
>  tracecmd/trace-cmd.c           |   4 +
>  tracecmd/trace-listen.c        |  10 +-
>  tracecmd/trace-msg.c           | 249 ++++++++++-
>  tracecmd/trace-record.c        | 773 +++++++++++++++++++++++++++++++--
>  tracecmd/trace-setup-guest.c   | 247 +++++++++++
>  tracecmd/trace-usage.c         |  22 +-
>  12 files changed, 1695 insertions(+), 92 deletions(-)
>  create mode 100644 tracecmd/trace-agent.c
>  create mode 100644 tracecmd/trace-setup-guest.c
>
> --
> 2.19.1
>


-- 
Slavomir Kaslev
