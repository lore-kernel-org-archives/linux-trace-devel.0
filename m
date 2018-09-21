Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr1-f46.google.com ([209.85.221.46]:45066 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389651AbeIUQws (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 12:52:48 -0400
Received: by mail-wr1-f46.google.com with SMTP id 20-v6so12424869wrb.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 21 Sep 2018 04:04:26 -0700 (PDT)
MIME-Version: 1.0
From: Tzvetomir Stoyanov <tzvmware@gmail.com>
Date: Fri, 21 Sep 2018 14:04:14 +0300
Message-ID: <CACqStoeTGfJJUL2bm55Te3GBUmS1RoSshTHvPtrTkpegF--5Tg@mail.gmail.com>
Subject: power top libtraceevent integration
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hello Steven,
I started to work on power top integration with the traceevent
library, most of this is already completed. There are few issues,
which I'm not sure how to resolve and need an advice:
  1. Problem with the undefined reference to str_error_r(). As I see,
it is implemented in tools/lib/str_error_r.c and is not part of the
traceevent library. How we should handle this ? We can reimplement
str_error_r() as part of the library, using "__attribute__((weak))",
but this solution will not be portable. Or we can get rid of this
function, is it a must to use it ?
  2. In order to be used by autoconfig, the library requires
integration with pkg-config framework. We must prepare and install
relevant .pc file. I think we should do it in trace-cmd tree, and not
in linux kernel tree.

--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
