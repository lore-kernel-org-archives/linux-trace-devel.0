Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DC1C001DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 22:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjHCWyd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 18:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjHCWyc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 18:54:32 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028DB187
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Aug 2023 15:54:31 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-686f8614ce5so1357973b3a.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Aug 2023 15:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691103270; x=1691708070;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+LWDirIZ/aeGJRy4LZYvWr70f3QTgB9Np48fV/VtedQ=;
        b=X5OLO3tvGrWcEH6E9xqaBUtI+70+5DaCknxggdWE0g1jLZ5E4MWYFy6MXpN7SIBGfc
         vS4NOfOXxMWnPDD4DDF1WCpzaJ2ezjoBdoGEhieFWS+1Mrl0oGRyJBFIYQ6DdKrN7AwV
         lwf/u4LoWx0Dtwjjl00sVGVbNeB+H56eXjp/eFIQOWHVuxTZKv0RxKRIZKJsA+MY8e9X
         WB8pDor/n5iGuTG9NQTOGQrxxZbvpMb6rQM2WZ6s2xxqfsR5wAn9UbEIWBn7EdS/6SXK
         KB7L5v5km3so10hdUx6c8tM2HqjJS1kZHHH/qeLt/Osfaqd4kVcl431PFoSlQP3IHC37
         0DCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691103270; x=1691708070;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+LWDirIZ/aeGJRy4LZYvWr70f3QTgB9Np48fV/VtedQ=;
        b=bOlDWNZ7HNQXlC1OpCAGEYbfiq8Hd3tFncNEDFlbC9Ohro40jwhblNIxy+ZJRp6plp
         M/r2ow0wwQbFCzFchNy2cM7sGfJwwr5a8BEqM9HeV0E98z2278QksPBo85Ldga+uiF+5
         lQYOsr3en+azZXDO/Uk6QPuJG3hJSFo4ww/gYrGSjOWS+mKQjY2F6ii4niQxLfPyVOUy
         YowXEJDq9YO0Q0HQ/XWF1A5+Tszi9VaixmG1x0xkHf4pd25tuOo1u4UEKeTxcM9pJQjX
         j6lelGc85si5V8x+wwmr9cxfTHAnWGRu5Q7aybdaQMisGBnEmEfqFd+cs178Ve34a/FM
         zDPQ==
X-Gm-Message-State: AOJu0YzTbs8jmPMt2UjqgekenV2Rmj7y/MyBSY1HUTxkXPyUJZhXMARK
        wC6BdoLyl75txjnB7JlsIrq4ThY8fa2puQ==
X-Google-Smtp-Source: AGHT+IFGdLSviyM7ddhS2X//0v1NDuvG+FWQO44BffL9CyFLK6Ozo83grUtrmCFDkKmkSPS3UYq2jw==
X-Received: by 2002:a17:90a:be04:b0:268:5c2f:f0c7 with SMTP id a4-20020a17090abe0400b002685c2ff0c7mr124524pjs.5.1691103269941;
        Thu, 03 Aug 2023 15:54:29 -0700 (PDT)
Received: from 3xKetch.lan ([2601:600:a17f:b422::ffc])
        by smtp.gmail.com with ESMTPSA id o14-20020a17090a4b4e00b00268b439a0cbsm351120pjl.23.2023.08.03.15.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 15:54:29 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2 0/5] histograms: bug fixes and convention compliance
Date:   Thu,  3 Aug 2023 18:53:58 -0400
Message-ID: <20230803225413.40697-1-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>

Changes in v2:
 * Renamed interface from histograms.h to traceeval-hist.h.
 * Internal traceeval_type arrays terminated by size rather than type.
 * type_alloc() guarantees traceeval_type name field is a valid pointer.
 * traceeval_release() sets released pointers to NULL.
 * Conditional simplifications and fixes across the board. 
 * Removed function stubs and their interface definitions.
 * Added a timestamp flag.
 * Added typedefs for traceeval_dynamic helper function signatures. 
 * Documentation follows established conventions (kernel docs, line comments).
 * Documentation moved from interface to source code.
 * Internal testing interface.
 * General documentation spell checking.

Since the addition of the traceeval_dynamic function signature typedefs,
warnings pertaining to these function signatures and traceeval_type have
popped up. Steven, Ross, and anyone else, any ideas on why these
warnings are showing up?

Warning from function signatures in include/traceeval-hist.h, line 65 and 69:
	warning: ‘struct traceeval_type’ declared inside parameter list will
	not be visible outside of this definition or declaration

		struct traceeval_type *);

Warning from dyn_release call in src/histograms.c line 258:
	warning: passing argument 2 of
	‘(defs + (sizetype)(i * 48))->dyn_release’ from incompatible
	pointer type

		defs[i].dyn_release(data[i].dyn_data, &defs[i]);

	note: expected ‘struct traceeval_type *’ but argument is of type
	‘struct traceeval_type *’

Warning from dyn_cmp call in src/histograms.c line 409:
	warning: passing argument 3 of ‘type->dyn_cmp’ from incompatible
	pointer type

		return type->dyn_cmp(orig->dyn_data, copy->dyn_data, type);

	note: expected ‘struct traceeval_type *’ but argument is of type
	‘struct traceeval_type *’

---
v1 discussion: https://lore.kernel.org/linux-trace-devel/20230731212542.3fb668b1@gandalf.local.home/T/

Stevie Alvarez (Google) (5):
  histograms: Initial histograms interface
  histograms: Add traceeval initialize
  histograms: Add traceeval release
  histograms: Add traceeval compare
  histograms: Initial unit tests

 Makefile                 |   2 +-
 include/traceeval-hist.h | 135 ++++++++++
 include/traceeval-test.h |  15 ++
 src/Makefile             |   1 +
 src/histograms.c         | 522 +++++++++++++++++++++++++++++++++++++++
 utest/.gitignore         |   1 +
 utest/Makefile           |  35 +++
 utest/eval-test.h        |  13 +
 utest/eval-utest.c       |  28 +++
 utest/traceeval-utest.c  | 217 ++++++++++++++++
 10 files changed, 968 insertions(+), 1 deletion(-)
 create mode 100644 include/traceeval-hist.h
 create mode 100644 include/traceeval-test.h
 create mode 100644 src/histograms.c
 create mode 100644 utest/.gitignore
 create mode 100644 utest/Makefile
 create mode 100644 utest/eval-test.h
 create mode 100644 utest/eval-utest.c
 create mode 100644 utest/traceeval-utest.c

-- 
2.41.0

