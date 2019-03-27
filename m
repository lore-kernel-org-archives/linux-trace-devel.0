Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18B4C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EF5A20700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfC0QDn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:03:43 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:34645 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfC0QDn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 12:03:43 -0400
Received: by mail-pf1-f169.google.com with SMTP id b3so8550070pfd.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Mar 2019 09:03:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pCoUyrDZvFSieyuHq7/DLAfegRm53JF05cBHOI4g8Y8=;
        b=SRPsFogVnHruELcANecj5IElqu8QkgdQq0PJaLeYVokIjosDT/z1IYWSEMIp1MldLN
         ammF17pr8fAXdKYw4CU+noG8I7wl30WKpfwdd3yKJh4gFeDHRKqmFgjzZrM8n5GY7Xid
         zaAF0DbJfJP46DY1ha16DdYdGwxfvfdZ6laCJuFINb3MkBdb9pKN6awfblma6oq5RsnR
         Ro683inpPncPPBLnnb4boP34k8VBaK1lbL3x14pMLNnqMV1kPyGruUxbVhW/TH9KU1+C
         APlqXUaVuH8jM2k6QMSQF11NuPkzutX+4ppXBYdTbY5oRSfBI0ICIkAPMEvK6Qm3W7gO
         Mltw==
X-Gm-Message-State: APjAAAXs2Q857B6+B52Zm9TK7g1vPnKKc32Ra1dRvErZ7UkIm1qGvWhG
        HI6q8E9MCFg/XbTUXxAAADM=
X-Google-Smtp-Source: APXvYqxXgJdMNZi7FCtt3gDfi4rguXJBZVhTNY7YhV06OaZSjVsuO/nwFzAdgZZmeQrH6PQflwFpFA==
X-Received: by 2002:a63:c204:: with SMTP id b4mr34755188pgd.335.1553702622897;
        Wed, 27 Mar 2019 09:03:42 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id p88sm36150806pfa.80.2019.03.27.09.03.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 09:03:42 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [RFC 0/7] NumPy Interface for KernelShark
Date:   Wed, 27 Mar 2019 18:03:16 +0200
Message-Id: <20190327160323.31654-1-ykaradzhov@vmware.com>
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
tracing data via scripts, but it also opens the door for
exposing the kernel tracing data to the instruments provided by
the scientific toolkit of Python (matplotlib, scikit-learn) or
maybe even PyTorch and TensorFlow in the future.

Disclaimer: I am not very good in Python. Please check as carefully
as possible :-)

Yordan Karadzhov (7):
  kernel-shark: kshark_string_config_alloc() must take no arguments
  kernel-shark: Add new dataloading method to be used by the NumPu
    interface
  kernel-shark: Prepare for building the NumPy interface
  kernel-shark: Add the core components of the NumPy API
  kernel-shark: Add Numpy Interface for processing of tracing data
  kernel-shark: Add automatic building of the NumPy interface
  kernel-shark: Add basic example demonstrating the NumPy interface

 kernel-shark/CMakeLists.txt                 |   3 +
 kernel-shark/README                         |  12 +-
 kernel-shark/bin/sched_wakeup.py            |  96 +++++++
 kernel-shark/build/py/libkshark_wrapper.pyx | 264 ++++++++++++++++++++
 kernel-shark/build/py/np_setup.py           |  87 +++++++
 kernel-shark/build/py/pybuild.sh            |  26 ++
 kernel-shark/src/CMakeLists.txt             |  39 +++
 kernel-shark/src/libkshark-configio.c       |   2 +-
 kernel-shark/src/libkshark-py.c             | 176 +++++++++++++
 kernel-shark/src/libkshark.c                | 128 ++++++++++
 kernel-shark/src/libkshark.h                |   9 +-
 11 files changed, 838 insertions(+), 4 deletions(-)
 create mode 100755 kernel-shark/bin/sched_wakeup.py
 create mode 100644 kernel-shark/build/py/libkshark_wrapper.pyx
 create mode 100644 kernel-shark/build/py/np_setup.py
 create mode 100755 kernel-shark/build/py/pybuild.sh
 create mode 100644 kernel-shark/src/libkshark-py.c

-- 
2.19.1

