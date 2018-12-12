Return-Path: <SRS0=dEKL=OV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr680083.outbound.protection.outlook.com ([40.107.68.83]:11474
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727845AbeLLQ73 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Dec 2018 11:59:29 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 5/5] kernel-shark-qt: Version 1.0.0
Date: Wed, 12 Dec 2018 16:58:50 +0000
Message-ID: <20181212165826.8218-6-ykaradzhov@vmware.com>
References: <20181212165826.8218-1-ykaradzhov@vmware.com>
In-Reply-To: <20181212165826.8218-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/CMakeLists.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/CMakeLists.txt b/kernel-shark-qt/CMakeLists.tx=
t
index d92bc3d..46137a3 100644
--- a/kernel-shark-qt/CMakeLists.txt
+++ b/kernel-shark-qt/CMakeLists.txt
@@ -4,8 +4,8 @@ cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
 # Set the name and version of the project
 project(kernel-shark-qt)
=20
-set(KS_VERSION_MAJOR 0)
-set(KS_VERSION_MINOR 9)
+set(KS_VERSION_MAJOR 1)
+set(KS_VERSION_MINOR 0)
 set(KS_VERSION_PATCH 0)
 set(KS_VERSION_STRING ${KS_VERSION_MAJOR}.${KS_VERSION_MINOR}.${KS_VERSION=
_PATCH})
 message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
--=20
2.17.1
