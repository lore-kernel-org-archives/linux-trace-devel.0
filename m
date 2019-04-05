Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85367C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51FD820651
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbfDEKOX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:14:23 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41693 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730400AbfDEKOW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:14:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id r4so7284243wrq.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 03:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6AW0RmmMYOgpBr8y3nkO3d5Wp0jLXIw/fxUYmHuwbZA=;
        b=dTaGgMWfacNAkh1+BMBL95IPg0SKDQqkib/ImdYa7gLX9uiA5t6tGmEqHyYZZku5Ca
         zNvXUJt/0B839yiWyaFD4hQKX27y9khbLlxzuf7QRbsVFfSoVcYSHpkLHf7Kuya8Sngk
         ZHgtg/Z1BXG+s2IvSbk7O0eNUmOrqYS8VpoKuMb9aUGgY2DNG0JM+ozzk9sBrFbbkMC0
         O2A5PWpnsm0IzGXAlTsDci4uV2zkdvNCXa3+rnFTD0ujSwWf9NLkX5kZsHvnVfKG+rAM
         J9781NI8eQslBcPOUZUSAaAwZDI8NXpA6WZtT/r8GP4FOGgJtJ86sR8ghQp2H+/R1zgE
         Qrsw==
X-Gm-Message-State: APjAAAUaYKycdTsMknkvKamJjR2mN06WT7wOxscffhiVLAld6U9cNXii
        474PEpge45w1e5JaXXL21Ng=
X-Google-Smtp-Source: APXvYqyVa5/9mN1CcealEX7SMwIU4TBsHiZ9LIGSEbXZoM08SNsv8iD1w2yj1Mr1Iz0EOTgDsL4d9w==
X-Received: by 2002:a5d:4a4d:: with SMTP id v13mr7921847wrs.169.1554459261201;
        Fri, 05 Apr 2019 03:14:21 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a187sm1851124wma.32.2019.04.05.03.14.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 03:14:20 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC v2 0/6] NumPy Interface for KernelShark
Date:   Fri,  5 Apr 2019 13:14:05 +0300
Message-Id: <20190405101411.25466-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

NumPy is an efficient multi-dimensional container of generic data.
It uses strong typing in order to provide fast data processing in
Python. The NumPy interface will allow sophisticated analysis of
tracing data via scripts, but it also opens the door for exposing
the kernel tracing data to the instruments provided by the scientific
toolkit of Python (stats, matplotlib, scikit-learn, ...) or maybe
even to PyTorch and TensorFlow in the future.

Disclaimer: I am not very good in Python. Please check as carefully
as possible :-)

Changes in v2:
 - Patch "[RFC 1/7] kernel-shark: kshark_string_config_alloc() must
   take no arguments" has been dropped from the patch-set because it
   was applied by Steven.
 - Proper clean up in the case when data_matrix_alloc() fails to
   allocate memory.
 - in kspy_read_event_field(), tep_find_event() is use instead of
   tep_find_event_by_name(). This makes the retrieval of the field
   value more efficient.
 - Fixed memory leak in kspy_new_session_file().
 - Python code follows the PEP8 Style Guide.
 - load_data() returns a Python dictionary. The user can specify the
   data-fields to be loaded via the named parameters of the function.

IMPORTANT: the patch-set must be applied on top of
[RFC 1/7] kernel-shark: kshark_string_config_alloc() must take no arguments

Yordan Karadzhov (6):
  kernel-shark: Add new dataloading method to be used by the NumPu
    interface
  kernel-shark: Prepare for building the NumPy interface
  kernel-shark: Add the core components of the NumPy API
  kernel-shark: Add Numpy Interface for processing of tracing data
  kernel-shark: Add automatic building of the NumPy interface
  kernel-shark: Add basic example demonstrating the NumPy interface

 kernel-shark/CMakeLists.txt                 |   3 +
 kernel-shark/README                         |  12 +-
 kernel-shark/bin/sched_wakeup.py            | 106 +++++++
 kernel-shark/build/FindNumPy.cmake          |  35 +++
 kernel-shark/build/py/libkshark_wrapper.pyx | 302 ++++++++++++++++++++
 kernel-shark/build/py/np_setup.py           | 101 +++++++
 kernel-shark/build/py/pybuild.sh            |  29 ++
 kernel-shark/src/CMakeLists.txt             |  59 +++-
 kernel-shark/src/libkshark-py.c             | 175 ++++++++++++
 kernel-shark/src/libkshark.c                | 136 +++++++++
 kernel-shark/src/libkshark.h                |   7 +
 11 files changed, 954 insertions(+), 11 deletions(-)
 create mode 100755 kernel-shark/bin/sched_wakeup.py
 create mode 100644 kernel-shark/build/FindNumPy.cmake
 create mode 100644 kernel-shark/build/py/libkshark_wrapper.pyx
 create mode 100644 kernel-shark/build/py/np_setup.py
 create mode 100755 kernel-shark/build/py/pybuild.sh
 create mode 100644 kernel-shark/src/libkshark-py.c

-- 
2.19.1

