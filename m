Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C03C04A95
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Sep 2022 21:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbiI1VQH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 17:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiI1VPs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 17:15:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AD54DB05
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 14:10:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id r62-20020a252b41000000b006af00577c42so12392901ybr.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Sep 2022 14:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date;
        bh=hDI7oOb/blNpBn+OWUf7JYeJXA+147eoMV313gi+c+M=;
        b=Bfxe+BVI3KgUOdvBFoVgtiSjbR/6uxa7/77OuIV9ICi8XLYb/7/N3dWAFPiY5RBx1c
         7SqdBXMyBpGz2Ic88mwFffFdfiLQ5c0+k+PBdIbH63e+bxzt+2y0Ms+OlaL+SpOIM6Yw
         HmkA2ch8aoCbQFBasTXBGhMJKFRLjkxyv/ihLadtns4lF8zC+ZDyVseBO0rxMD5Npf6r
         weqaKvAMUX/5qLLSAb/IMWDFcw8fuZwWLaefnwNBW89238iQ5dJCmU2eaHE5b5yY6RPc
         EOzeqPERuvJyvUpBSq0wr8OGOH3fY3C91KnTE2FHOQ0zH49I0xo76SIOBfRV4gdI7uZn
         gw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=hDI7oOb/blNpBn+OWUf7JYeJXA+147eoMV313gi+c+M=;
        b=Stly39WAmiY1zP62JfKMjzUF8l0e3X4Qp1ZHD8h7MYv9Mt6O8SzGjdK0D6CcL1EaYq
         D4qumPUx98OQhpwoP1JzEGJyJFTCTNAkfPBnekhcDiZn60EA+P5+PqE+t/qx1wf/DNAM
         7tXYmCtsaXHY/70YMhfhlsmSM4aZDBzW+xDO1kQNuviGtt3vPbhwwGv9c1R+sM+z4pkl
         b8D27ic6+Htx6W55xOnUgJBVIf0mhbKWCB9cMf+l3LOGFA/rEry6INzZsPTifZx/9S4l
         zxENTPIsScfrKEUQPL39EaKq2oF4AU9UFwKEoJwEkWruacxnRdM9qxNzfNpX1QFTBn0y
         MIQQ==
X-Gm-Message-State: ACrzQf3Vo4wz03QNeETP/J1B0RYc747nUlUd2mFr1LN0ykeOqaWhLYpr
        B+iuz0CI1JRLNT3FRk17xQgu/ardSxaK+02rAFjNXPCutJAk3FS+OVKSDL8YHpyuJUGN42pGHu/
        wdQjYMSgGmjq77H4NDrAPFBTo7vWyzM6iKM4wTS4grsvdGi3tJN2qammakxzJPMlclyH8EbIcWp
        9+im0=
X-Google-Smtp-Source: AMsMyM4nOMPWkxKsuq9BLvMersleNZo4OyQATuNXWFv2vPsXmoxgLRQRws4IicpsSXRkQ9OcWG8QEDr2UKd+
X-Received: from irogers.svl.corp.google.com ([2620:15c:2d4:203:19ee:d06c:2039:a1ba])
 (user=irogers job=sendgmr) by 2002:a81:66c4:0:b0:354:3d8f:f5b0 with SMTP id
 a187-20020a8166c4000000b003543d8ff5b0mr2272211ywc.273.1664399375611; Wed, 28
 Sep 2022 14:09:35 -0700 (PDT)
Date:   Wed, 28 Sep 2022 14:09:31 -0700
Message-Id: <20220928210931.1803799-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Subject: [PATCH] Initialize field_size prior to use
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Building with CC=clang yields:

```
  COMPILE FPIC       event-parse.o
event-parse.c:4313:17: warning: variable 'field_size' is uninitialized when used here [-Wuninitialized]
                                           offset, field_size)) {
                                                   ^~~~~~~~~~
event-parse.c:4108:25: note: initialize the variable 'field_size' to silence this warning
        unsigned int field_size;
                               ^
                                = 0
1 warning generated.
```

dynamic_offset_field will compute the length of the field and so use
that to give field_size a legitimate value.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 980e980..b3e0ea7 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -4308,7 +4308,7 @@ eval_num_arg(void *data, int size, struct tep_event *event, struct tep_print_arg
 	case TEP_PRINT_DYNAMIC_ARRAY:
 		/* Without [], we pass the address to the dynamic data */
 		dynamic_offset_field(tep, arg->dynarray.field, data, size,
-				     &offset, NULL);
+				     &offset, &field_size);
 		if (check_data_offset_size(event, arg->field.name, size,
 					   offset, field_size)) {
 			val = (unsigned long)data;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

