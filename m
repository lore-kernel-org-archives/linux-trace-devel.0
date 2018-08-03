Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40372 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732330AbeHCQ0b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 12:26:31 -0400
Received: by mail-wm0-f68.google.com with SMTP id y9-v6so6668593wma.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Aug 2018 07:29:54 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 0/6] Add visualization model for the Qt-based KernelShark
Date: Fri,  3 Aug 2018 17:29:31 +0300
Message-Id: <20180803142937.3970-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches introduces the second part of the C API used by
the Qt-based version of KernelShark. This part of the API is responsible
for the visual navigation and browsing inside the trace data.

This is the third version of this series of patches.
Major changes from v2 are:

[old 1/7] The "Changes type of the fields" is now a separate patch and isn't
part of this series.

[1/7] As suggested by Steven Rostedt, the binary search functions are modified
in order to avoid the ambiguity of the returned value in the case when no
kshark_entry has been found inside the range.

[2/7] The change above affects the logic in ksmodel_set_lower_edge(),
ksmodel_set_upper_edge() and ksmodel_set_next_bin_edge().

[4/7] General revision (debugging and simplification) of the logic,
responsible for mapping the primary data request into a list of
collection-compatible data requests.


Yordan Karadzhov (VMware) (6):
  kernel-shark-qt: Add generic instruments for searching inside the
    trace data
  kernel-shark-qt: Introduce the visualization model used by the
    Qt-based KS
  kernel-shark-qt: Add an example showing how to manipulate the Vis.
    model.
  kernel-shark-qt: Define Data collections
  kernel-shark-qt: Make the Vis. model use Data collections.
  kernel-shark-qt: Changed the KernelShark version identifier.

 kernel-shark-qt/CMakeLists.txt             |    2 +-
 kernel-shark-qt/examples/CMakeLists.txt    |    4 +
 kernel-shark-qt/examples/datahisto.c       |  159 +++
 kernel-shark-qt/src/CMakeLists.txt         |    4 +-
 kernel-shark-qt/src/libkshark-collection.c |  805 +++++++++++++
 kernel-shark-qt/src/libkshark-model.c      | 1223 ++++++++++++++++++++
 kernel-shark-qt/src/libkshark-model.h      |  159 +++
 kernel-shark-qt/src/libkshark.c            |  278 +++++
 kernel-shark-qt/src/libkshark.h            |  172 +++
 9 files changed, 2804 insertions(+), 2 deletions(-)
 create mode 100644 kernel-shark-qt/examples/datahisto.c
 create mode 100644 kernel-shark-qt/src/libkshark-collection.c
 create mode 100644 kernel-shark-qt/src/libkshark-model.c
 create mode 100644 kernel-shark-qt/src/libkshark-model.h

-- 
2.17.1
