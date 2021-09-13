Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A4EC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA6760F6D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbhIMM3Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhIMM3Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:24 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24364C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:09 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m9so14435783wrb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4eNSf3fXIhuexSWrZzu9VRBujGIACDgGvnuES2rhjo4=;
        b=hiJewWSQQXKW0uIlYcqh6RmLjU+dhMr1QjgUIJuIeP1Ya9O+1r0sM0MY9QLP2nNEbn
         paYLqmj9RK2DELUzohg8dcoSJWjByuifzGMVXwW+GoqZSLDr3RosokXIfin32RZ8DLAK
         p2QgLxMcW/DqWYJLp3P3sbeMs/ZSOXXm7lj89WnQGJ8Z+HK3vTEuN1T2SgSqh41cd8aN
         sOEWweFdQZvLsYtEg4viuCk40JOSgwGyA5W3Z0yY+shCnYqYxTVzs+1ylNkM3yniWnI0
         ll0Fu5pXoKsDXVGm9prD8QPs6bl2io0ytuxMfFn3oJNlk87Q0jb1Bi1NWMWmt5KzxMo0
         0qwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4eNSf3fXIhuexSWrZzu9VRBujGIACDgGvnuES2rhjo4=;
        b=D804CpcfkWiBptBtLlenRoz8brRkV2yx70tvkTAazr5TLJ+LE2pczwS85GBo91RPhk
         ewfupvkfdc2bp7Xdpj93N9aOvdTjoL7nc32M9VdkR0sDcwzMTEemZSFJtDSgYbNe/iLR
         +yp8PBU3JmU7gj+DcQ0n7l47QEiPs8iir+ti+4qIy4tFlZGvVbvQCwMr/LtpUtazBn6t
         uSJH7ODvHvx/jcT9jnLZEN51LJrpmwQAsavh7eVccfY+81vAlMySfwP8tcInfGpccgDU
         MpkRbYs+iqzgy93LnSpjKF+cR2bYE5AP80Hs3gQxCJ59DsjXw7ZCPEU6YlqLt5ssZdBE
         eK4w==
X-Gm-Message-State: AOAM531wGBz15kgch1D3egU66d76VUjPxKFOW4tg6KswtsncT9pD+k0T
        MTKhHNvHW896ADfIqJZNTDMBcD078OQ=
X-Google-Smtp-Source: ABdhPJyO990rGYTxB4ZVqbSIG9EihtRmdzrXmyfi9EoN1PeNuNHKApVeuXYBnVQ8zJhZ+0nUjCZ4wQ==
X-Received: by 2002:a5d:58c9:: with SMTP id o9mr12466066wrf.279.1631536087809;
        Mon, 13 Sep 2021 05:28:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 06/21] trace-cmd library: Set long size to the input tep handler when it is read from the file
Date:   Mon, 13 Sep 2021 15:27:44 +0300
Message-Id: <20210913122759.3672494-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Setting the long size to the input tep handler in tracecmd_read_headers()
API may be too late, as this tep handler is used to read and parse data
from the file before that. The most suitable place for that is
tracecmd_alloc_fd() API, right after reading the long size from the
file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e5c8c332..3d7f1c48 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -860,8 +860,6 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
 	if (ret < 0)
 		return -1;
 
-	tep_set_long_size(handle->pevent, handle->long_size);
-
 	if (state <= handle->file_state)
 		return 0;
 
@@ -3337,6 +3335,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	do_read_check(handle, buf, 1);
 	handle->long_size = buf[0];
+	tep_set_long_size(handle->pevent, handle->long_size);
 
 	read4(handle, &page_size);
 	handle->page_size = page_size;
-- 
2.31.1

