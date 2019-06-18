Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD3F4C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BF3C20B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyCUdPFQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfFROkJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:40:09 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:54507 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFROkJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:40:09 -0400
Received: by mail-wm1-f51.google.com with SMTP id g135so3579986wme.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cVr6VhA1spYLniuDKsUkVVAiQwMfG3SFwQb76EFECLk=;
        b=fyCUdPFQ9FpDzvhj4YuXSYnGVUwbHfBHF9nGjFR7JlmRXRKSAHfhBPKWOSxHsFMAUL
         w/9WGOaO1YlZft6ebe9hMUwG7/udcyYcBWaIdE3BJn7AhRdgTOiNkWxTeo1bRDMAwynz
         +fltclxV2ZpwakPhCv1oUHt2mKTEiOj9mvQOWNNzruMlgJZLrc1FhD998C9oB5+MnAy8
         KSfMcmutuTzdFAlPIa3p/7/7HOPX9Tc71V29cnFLIYlhYvLCv2Ep4ENRmuLwGN21mWGY
         lc0nFRwJMyaV1KqX1dzNIqD/sGeBo0DUD/fGSA7l4wv/9x9+kjZJSnMyGVPYEsftNhAw
         wQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cVr6VhA1spYLniuDKsUkVVAiQwMfG3SFwQb76EFECLk=;
        b=cA7kmFNOjB+bmJmnWIN7l+A7g7C8niI8SmE20FnJrs1o/TdUyQweka7p3pHMEAGBYE
         sgGrTzu3M8baZiSBvl7D0CVwOrWZEyR+eB7eVoIaX+trJ8rptqoJ2z6/qggZdffrC0wx
         9z9+gQ7+cN3K1U3P4zEp15rjltiYMVgWK/hCLeOLAldMR9dgCZ04Bo54IE2FtbwEoiT0
         4cKv8d96rl96MCRkAhaJmr7s7f0eXT7eZ+0tQfYNQALUVCqTc/caV1Sj+4T2I5dgAU3J
         VFBlaqY9KliO02eli94FIgdVKLU8aY34O8sKJa4zH2SbVpkaBFmKNsB75Bk3tk8L+IxX
         Efqw==
X-Gm-Message-State: APjAAAXJzR6derc7zYP9Zl2kluwyVELLQkuY/D8CVa8SpJtRI0uwr47/
        mnLeJ9R4S80z+yGmjtQLA+1DaRY=
X-Google-Smtp-Source: APXvYqxljLM7T5gUzB1ypXsGAD0Q8T+ka5vUKw3UR+mfUYdiTf0+hNcq3dffYT2uFG/9A0kDhxOw2A==
X-Received: by 2002:a1c:1947:: with SMTP id 68mr3846000wmz.165.1560868806831;
        Tue, 18 Jun 2019 07:40:06 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm2411808wma.32.2019.06.18.07.40.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:40:05 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 00/13] Add VM kernel tracing over vsockets and FIFOs
Date:   Tue, 18 Jun 2019 17:39:45 +0300
Message-Id: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset adds support for tracing guest kernels to trace-cmd.

Changes in v11:
 - fix flushing tracing data bug when doing VM recording

Changes in v10:
 - add support for specifying VMware Workstation guests by name on the command line
 - add docstring for tracecmd_create_recorder_virt()
 - add a comment on why we need to poll() in direct_splice_data()

Changes in v9:
 - none

Changes in v8:
 - switched protocol message encoding of ports to text
 - switched ports data type to unsigned since vsockets port numbers can overflow int and be confused with errors codes by other code
 - added automatic naming for guests with no names (for VMware Workstation guests currently)
 - added --debug option to trace-cmd agent

Changes in v7:
 - fixed potential memory leak in add_arg()
 - call msg_free() in tracecmd_msg_recv_trace_req() eventhough we're stealing
   the message buffer
 - added is_guest and is_agent macros and use throughout tracecmd_record.c
   instead of testing instance->flags bits
 - avoid memory allocation in make_dir()

Changes in v6:
 - added specialized data transfer path over FIFOs making single splice() per
   iteration
 - made tracecmd_msg_recv_trace_req/tracecmd_msg_recv_trace_resp more defensive
   to invalid messages

Changes in v5:
 - add FIFOs transport for tracing data
 - fixed a bug in tracecmd_msg_wait_close

Changes in v4:
 - detect and use splice(2) on vsock sockets if possible
 - switch port numbers to unsigned int
 - trace-cmd record --date flag is now set for all guests if provided by the user
 - removed grow_cap and exponential buffer size growth

Changes in v3:
 - addressed Steven's feedback
 - detect and disable guest tracing if <linux/vm_sockets.h> is not available
 - the --date flag is now treated as global for all guest instances
 - fixed a bug that caused --date to be ignored for host tracing data when tracing guests

Changes in v2:
 - rebased on top of protocol V3
 - fixed system clock timestamps with the --date flag

Slavomir Kaslev (11):
  trace-cmd: Make ports unsigned int
  trace-cmd: Add tracecmd_create_recorder_virt() function
  trace-cmd: Add VM tracing protocol messages
  trace-cmd: Add buffer instance flags for tracing in guest and agent
    context
  trace-cmd: Add VM kernel tracing over vsockets transport
  trace-cmd: Use splice(2) for vsockets if available
  trace-cmd: Add `trace-cmd setup-guest` command
  trace-cmd: Try to autodetect number of guest CPUs in setup-guest if
    not specified
  trace-cmd: Add setup-guest flag for attaching FIFOs to the guest VM
    config
  trace-cmd: Add splice() recording from FIFO without additional pipe
    buffer
  trace-cmd: Add support for tracing VMware Workstation VMs by name

Slavomir Kaslev (VMware) (1):
  trace-cmd: Switch stop recording signal to SIGUSR1

Steven Rostedt (VMware) (1):
  trace-cmd: Detect if vsockets are available

 Makefile                       |   7 +
 include/trace-cmd/trace-cmd.h  |  20 +-
 lib/trace-cmd/trace-recorder.c | 154 ++++--
 tracecmd/Makefile              |   5 +
 tracecmd/include/trace-local.h |  29 ++
 tracecmd/trace-agent.c         | 294 +++++++++++
 tracecmd/trace-cmd.c           |   4 +
 tracecmd/trace-listen.c        |  10 +-
 tracecmd/trace-msg.c           | 274 ++++++++++-
 tracecmd/trace-record.c        | 865 +++++++++++++++++++++++++++++++--
 tracecmd/trace-setup-guest.c   | 247 ++++++++++
 tracecmd/trace-usage.c         |  22 +-
 12 files changed, 1824 insertions(+), 107 deletions(-)
 create mode 100644 tracecmd/trace-agent.c
 create mode 100644 tracecmd/trace-setup-guest.c

-- 
2.20.1

