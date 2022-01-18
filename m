Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901F8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jan 2022 03:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345178AbiARD7x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 22:59:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:45330 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242190AbiARD7w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 22:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642478392; x=1674014392;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=RG2HPTqSasXcS4voFW+FHHO+uv37xI/v13jBTHgJZXU=;
  b=JxU2yXViHzotRWEQehfMvH67zi88cpMYo9MEhXk2jGD2HTdX7CqVi/2R
   EYHM9eH74598J1uN6ZIsfTTxXp0kDiQ9XHnIb3NKZyJpwuIns5cWd7Cgq
   CruC3Indjv+Yfa9O9z3dRX7Lk4kRcWgPyNniePJppM3Q9yTnfnvK724rO
   edplWfZOL823DxRdK5CEHKlGZBN+gUoSg7Y01WXF1ttK1rspLypHaKMEy
   AAuCOCtgcHYlOWr0EBLrFOlvgpvZ1q2srzjsGbh3gIoVnS5He+qa4/2KA
   zeng8eYwfzE69k1vLtQDe7XOqOeLWDcADLUxaNqd+WeD2F9HqzmUNynW3
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="244530371"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="244530371"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 19:59:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="625378796"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 17 Jan 2022 19:59:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 17 Jan 2022 19:59:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 17 Jan 2022 19:59:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 17 Jan 2022 19:59:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awwauSeXBdf1O9vbQMF2t0gRP6VuNMqQcGdLtM7o2s9Adqe+6a4PEy1/B8ijUYOUR2h4I3EB+1zsKPfr/CXs4frjkpA2pYzLDS4bnPM3gygRqGwrK6LzSOVgdb7Yy/rzy74/uNkcax2qjeQUbvBq/1aWsBvi6I9VGI9LF8UZRKt85PpNGN8UQxdyufPC1Lji5oZDsoIYBDgoElMDcy5PM3tdDdY857sMPwMXV6d8NwYjSbVnwcwu57gkUV328KpfXsQARG1vViQj/3gIr5uEM5884PpS46WOe2851UnwMyMckULYSWsK6qCWC4njfHQfb7iKIbdXP8ZZ7CfUn8yIWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KVApq5msNfscV+J+CQwJD4O4pi4cXDCLQl1+8SUrR7A=;
 b=moDXn3GNwS2zC2aGrh07M+93OfIw3mwEKxSDWKeC0h63WHs+Jrr/S2Oe5fJ2gmruCLfDZSCQ5OXSQnkJZgjq1PXtLyfe9uuhKEF294NkV0Ys+yZ5pm30j2pj+GhMSRkJ0D08tWAK2VaoqM7pUJ9ZJ6Dw5yh/H2hWptVmhQdXCH3wOWjlrz5R4wxAhhWfjAebM5aizVGDOetvHDnwQTF5P4a6B+1kfiiM/8b5h7uMLd2PPQ4T+5chRIs/O0ILFPlFsxeK9O/hEKRPUwUjUpk9ADzt4N1OZK47ndp7XjdN9mMOevpY7pX2K6ELk0BYQUeEgUGx5jAQqEW+KxQjdAPm5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32)
 by PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 03:59:48 +0000
Received: from MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409]) by MN2PR11MB4285.namprd11.prod.outlook.com
 ([fe80::38b5:756e:417:6409%5]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 03:59:48 +0000
From:   "Chen, Hongzhan" <hongzhan.chen@intel.com>
To:     "Chen, Hongzhan" <hongzhan.chen@intel.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        "y.karadz@gmail.com" <y.karadz@gmail.com>
Subject: RE: [PATCH] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch
Thread-Topic: [PATCH] kernel-shark: Add plugin for handling Xenomai
 cobalt_context_switch
Thread-Index: AQHYDB7+4keGkKV480y1F8Gvf8QzMqxoJx/g
Date:   Tue, 18 Jan 2022 03:59:48 +0000
Message-ID: <MN2PR11MB4285F116FD02668420B10E8CF2589@MN2PR11MB4285.namprd11.prod.outlook.com>
References: <20220118033342.25119-1-hongzhan.chen@intel.com>
In-Reply-To: <20220118033342.25119-1-hongzhan.chen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ecfcdd2-e2b3-425e-1aa2-08d9da36f8d8
x-ms-traffictypediagnostic: PH0PR11MB4855:EE_
x-microsoft-antispam-prvs: <PH0PR11MB4855B4FC09ED2C5C42212F2DF2589@PH0PR11MB4855.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ktFyB9Hj5N1vjtC+PoEmhzAo76i8H8Z4oKDzDX7r0L3jJtXV2GjM4ss2MRzQ4+zDyaLTW/J97b3M0wXr/vjBaJ8kAchVDAi0NOrfAMmjcRZAOEOLmkVm/EY2rKe/7ndW/lvNd/yDexjLVsnAJsIwo8bviKxl5rZ0S/sUkvf57GGslZILXZ3uXodQOBN1HKPD5wq2wInACB7fev0SWeUytg3UnBrUpbKx5Iq6l/BF5s9SThrc1RsuCzWnX9awWZ/XCdCFteewPqPMgQnJr1pJWKpK4sRl8gqH7V0zj0uR+5iJAvF7PpyYYhf9CastCU0LutKvACaGtaI+4IXqfj7nLm+FdDTRwUyGbElSuASchEJZYKXaKGahMnJU/3xMDrAcE5D+1qFaRfTfjLGenu/QQPCJxEyUGBri6V4pH7a1RrV7PzMyFR3wbLEFk0b9hpw05n7gsUmcuShyCq/TUyEDJRoPX5GDFFKlBvlm3N1EJWGADHLOriODV1xoypDM0Qx+4CsyWlZ2nLi80smXfLI+bDjNIktHXSjUtrzJ8+WLjBOv93Q8bZ1D58laLtLx4yaESKwJOVPNe1MYybs/9QEHtXqpUUgUl/ApRT8byJVS6coTbgsQ9+7b0XOKVJiqDIJGN/6i8Nbeqaq3nyLYfkIbDlkp9TBcVr6MR8uvZTI6k4yfc3aOMjvL7T71rRHoYI+cUZurMT5etgUqc+BpAbtpug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4285.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(86362001)(83380400001)(53546011)(38100700002)(76116006)(82960400001)(110136005)(33656002)(122000001)(66476007)(55016003)(66556008)(316002)(66946007)(64756008)(38070700005)(52536014)(30864003)(7696005)(9686003)(26005)(5660300002)(8936002)(71200400001)(8676002)(2906002)(508600001)(186003)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YFO+Di5Uw1tPWRWhD1w0oC4UfDAH4ResK/TCDNGSSHYFWYRHNNyAyj2M+t9V?=
 =?us-ascii?Q?5hq0ob7SYrPsdb+lvLqP1oBGyQsyV3oDjbgEu59eYTKCfAFIhAKb8+TfMT5A?=
 =?us-ascii?Q?lI8e/zXI+VglHjmVweijfCwebqpj97QCSjOmQNjxBy3/o5G4M57DlZA7MiiL?=
 =?us-ascii?Q?fFP+zrE5Q8TIPWrUs0mGMT2gkQiVXSh/fMpdtlFvFo1Do7xOEuTqShX6LBN5?=
 =?us-ascii?Q?IgeZ3Sc9PWZS+ko7ob0rJv2Q+HLqNW3YyLB50NrEdpb9pzHT/VHnUt230pAG?=
 =?us-ascii?Q?cGzq1a8CPYcSIxLCDLoudxydcKUsEEV3kmZxWdbqUeGZP4fRRn6l96dsUgVJ?=
 =?us-ascii?Q?dMA7HZFAEEQo8r//JBECjb9aJU0NWgw8z56jegFl2YD+WgvAh8GYIedzIpzK?=
 =?us-ascii?Q?ekAtPqWISfTF5wjY1JgVEHNVfEraSsbKFL6KMaH39+lSR0KLz8492GuEl4wI?=
 =?us-ascii?Q?Pk6KUSyCEbfizhFZ6ECaQAwTPzUtduQEYQDkjp7hW2JYezU34LVRnO5piVsK?=
 =?us-ascii?Q?I1uij94S1+0d2DuQnup3/8rUfsUKUuHqmUyVAru+PRWbaNi1Y+jahUAZoTM/?=
 =?us-ascii?Q?PgGdIWda4TgYgWs77W8+qFxD1UU9AO8qlRDV19wLRKpJsrz341kc8MjILZQb?=
 =?us-ascii?Q?5yQTsrIjlELHA/1LNa4/IjXIDD0igjSuvzibPpN7ipIv6itis4UBZ0HPdetw?=
 =?us-ascii?Q?V2uONGgrHq1uVAWkhNfke/zBRPXTNVr/2i0zRvKemrXI/6JCthFdrDveykTC?=
 =?us-ascii?Q?KfbHNMJv6pGSG71ajg2hjequitlxFe/4H23b99xQeUGg49l6tiiMnhu0gQrk?=
 =?us-ascii?Q?zXA5nr9jGx2AJpas2w/c7kVu7JGc+bAalKl3hUlyZZDCGyw5rKJY7FdFuPW2?=
 =?us-ascii?Q?e26qQAuk/JVksSePlL7xk1GDph7kuYSVObngjGm1IX7SYIyElZra1ZYIOP1P?=
 =?us-ascii?Q?Pd5b4kw2ARPx/DmI4d1nZBrZXbO9+JRNNQMy+9hP5ejSDArOW+Tm7gIJcpGq?=
 =?us-ascii?Q?OQ/lYZBXnsu1k/pV6+o3vVTGZamSTUNxWRfxclxrbhfjzUX1wieCPgjPxSCK?=
 =?us-ascii?Q?rxghZd7ATuyg13CRw7muWFxE/HTwZBpkMpOajgyCmznZaK4oDOm7CxQ9oj6d?=
 =?us-ascii?Q?d3AJXH+cZe1TQd7VZW3SENiTvg/Fh65lcqg/MwZ8JWNNMPxIEd+NeDm2AGWq?=
 =?us-ascii?Q?8/8nrcVO2iLvE9DlPy3xcWkW+zex8jjVUYU2si+sXsw38hTVLR5QW9+bnBOM?=
 =?us-ascii?Q?+2EBxT0FFcpu6A9zClHm9yZnHgaYQWsvmXI2Vt6PX1dYB+JRTIhWjCUo5n3d?=
 =?us-ascii?Q?vhvLyBWxqK9vbHOKNQrDgsOND98yyNmZCxH4KAtIsb3sU+KaVdHNoYw8Rb9N?=
 =?us-ascii?Q?dBI+jdOp/pe26X8B/43BhozEQid1RnuobXodBrHvMcqpp2HGJW+d8MwSkI+U?=
 =?us-ascii?Q?AU0hPneLdQ3Ro7rnxXFBnfZlAoeFQ9bJp6R9Nx4neBYqbbZk0Hdq7S5nUIck?=
 =?us-ascii?Q?wX9KoAqvv6aI0T3OIcmYF+NyUwSCT8Q/bZ5bu6jkjhm+A6Af6k6z9ctGXGmw?=
 =?us-ascii?Q?2pwE/i/dwMR9fYF74xfxiQ0mLZCCPOx1W8uHv31PHF5JLcZb2duKrEa9d+2R?=
 =?us-ascii?Q?Yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4285.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecfcdd2-e2b3-425e-1aa2-08d9da36f8d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 03:59:48.6699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CunJzJjh2i7K8BqGLiub97HCn5izJOYYkeWvEVzXPppXAyo68Fe6wMzLN30TZKKKdmp2EMKzjj8dczb+8HO4uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4855
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Sorry, Please ignore it. Email wrong address.=20

Regards

Hongzhan Chen

-----Original Message-----
From: Hongzhan Chen <hongzhan.chen@intel.com>=20
Sent: Tuesday, January 18, 2022 11:34 AM
To: linux-trace-devel@vger.kernel.org; y.karadz@gmail.com
Subject: [PATCH] kernel-shark: Add plugin for handling Xenomai cobalt_conte=
xt_switch

For Xenomai-cobalt enabled system, cobalt_switch_context means
that there is schedule and context switch in companion core(realtime
core), which we may need to do special treatment and take correct
action as main kernel sched_switch to visualize out-of-band state
of realtime tasks running in cobalt core. To achive our target,
we implement following:

  1. store corresponding cobalt_switch_context events into
     container data.
  2. modify pid stored in entry to be equal to next_pid to
     show correct color in cpu bar when cobalt_switch_context
     event happen.
  3. show cobalt blue hollow box to mark out-of-band state according
     to cobalt_switch_context events.
  4. clickable cobalt_switch_context plugin shapes.

Signed-off-by: Hongzhan Chen <hongzhan.chen@intel.com>

diff --git a/src/plugins/CMakeLists.txt b/src/plugins/CMakeLists.txt
index 3e170fa..16f080b 100644
--- a/src/plugins/CMakeLists.txt
+++ b/src/plugins/CMakeLists.txt
@@ -44,6 +44,10 @@ if (Qt5Widgets_FOUND AND TT_FONT_FILE)
                      SOURCE sched_events.c SchedEvents.cpp)
     list(APPEND PLUGIN_LIST "sched_events")
=20
+    BUILD_GUI_PLUGIN(NAME xenomai_cobalt_switch_events
+                     SOURCE xenomai_cobalt_switch_events.c CobaltSwitchEve=
nts.cpp)
+    list(APPEND PLUGIN_LIST "xenomai_cobalt_switch_events")
+
     BUILD_GUI_PLUGIN(NAME event_field_plot
                      MOC EventFieldDialog.hpp
                      SOURCE event_field_plot.c EventFieldDialog.cpp EventF=
ieldPlot.cpp)
diff --git a/src/plugins/CobaltSwitchEvents.cpp b/src/plugins/CobaltSwitchE=
vents.cpp
new file mode 100644
index 0000000..269de95
--- /dev/null
+++ b/src/plugins/CobaltSwitchEvents.cpp
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    CobaltSwitchEvents.cpp
+ *  @brief   Defines a callback function for Xenomai Cobalt context switch
+ *           events used to plot in cobalt blue the out-of-band state of
+ *           the task
+ */
+
+// KernelShark
+#include "libkshark.h"
+#include "libkshark-plugin.h"
+#include "plugins/xenomai_cobalt_switch_events.h"
+#include "KsPlotTools.hpp"
+#include "KsPlugins.hpp"
+#include "KsMainWindow.hpp"
+
+static KsMainWindow *ks4xenomai_ptr;
+
+/**
+ * @brief Provide the plugin with a pointer to the KsMainWindow object (th=
e GUI
+ * itself) such that the plugin can manipulate the GUI.
+ */
+__hidden void *plugin_set_gui_ptr(void *gui_ptr)
+{
+	ks4xenomai_ptr =3D static_cast<KsMainWindow *>(gui_ptr);
+	return nullptr;
+}
+
+/**
+ * This class represents the graphical element visualizing OOB state betwe=
en
+ *  two cobalt_switch_context events.
+ */
+class XenomaiSwitchBox : public LatencyBox
+{
+	/** On double click do. */
+	void _doubleClick() const override
+	{
+		ks4xenomai_ptr->markEntry(_data[1]->entry, DualMarkerState::B);
+		ks4xenomai_ptr->markEntry(_data[0]->entry, DualMarkerState::A);
+	}
+
+};
+
+/*
+ * Ideally, the cobalt_switch_context has to be the last trace event recor=
ded before
+ * the task is preempted. Because of this, when the data is loaded (the fi=
rst pass),
+ * the "pid" field of the cobalt_switch_context entries gets edited by thi=
s plugin
+ * to be equal to the "next pid" of the cobalt_switch_context event. Howev=
er, in
+ * reality the cobalt_switch_context event may be followed by some trailin=
g events
+ * from the same task (printk events for example). This has the effect of =
extending
+ * the graph of the task outside of the actual duration of the task. The "=
second
+ * pass" over the data is used to fix this problem. It takes advantage of =
the
+ * "next" field of the entry (this field is set during the first pass) to =
search
+ * for trailing events after the "cobalt_switch_context". In addition, whe=
n
+ * we find that it try to switch in-band because next-pid is zero, we pref=
er to
+ * skip this event because it try to leave oob not enterring.
+ */
+static void secondPass(plugin_cobalt_context *plugin_ctx)
+{
+	kshark_data_container *cSS;
+	kshark_entry *e;
+	int pid_rec, switch_inband;
+
+	cSS =3D plugin_ctx->cs_data;
+	for (ssize_t i =3D 0; i < cSS->size; ++i) {
+		switch_inband =3D plugin_cobalt_check_switch_inband(
+				cSS->data[i]->field);
+
+		/* we skip cobalt_switch_context that try to
+		 * switch into in-band state because we just handle
+		 * out-of-band
+		 */
+		if (switch_inband)
+			continue;
+		pid_rec =3D plugin_sched_get_pid(cSS->data[i]->field);
+		e =3D cSS->data[i]->entry;
+		if (!e->next || e->pid =3D=3D 0 ||
+		    e->event_id =3D=3D e->next->event_id ||
+		    pid_rec !=3D e->next->pid)
+			continue;
+
+		e =3D e->next;
+		/* Find all trailing events. */
+		for (; e->next; e =3D e->next) {
+			if (e->pid =3D=3D plugin_sched_get_pid(
+						cSS->data[i]->field)) {
+				/*
+				 * Change the "pid" to be equal to the "next
+				 * pid" of the cobalt_switch_context event
+				 * and leave a sign that you edited this
+				 * entry.
+				 */
+				e->pid =3D cSS->data[i]->entry->pid;
+				e->visible &=3D ~KS_PLUGIN_UNTOUCHED_MASK;
+
+				/*  This is the last trailing event, we finish
+				 *  this round.
+				 */
+				if (e->next->pid !=3D plugin_sched_get_pid(
+						cSS->data[i]->field))
+					break;
+			}
+		}
+	}
+}
+
+/**
+ * @brief Plugin's draw function.
+ *
+ * @param argv_c: A C pointer to be converted to KsCppArgV (C++ struct).
+ * @param sd: Data stream identifier.
+ * @param pid: Process Id.
+ * @param draw_action: Draw action identifier.
+ */
+__hidden void plugin_cobalt_draw(kshark_cpp_argv *argv_c,
+			  int sd, int pid, int draw_action)
+{
+	plugin_cobalt_context *plugin_ctx;
+
+	if (!(draw_action & KSHARK_TASK_DRAW) || pid =3D=3D 0)
+		return;
+
+	plugin_ctx =3D __get_context(sd);
+	if (!plugin_ctx)
+		return;
+
+	KsCppArgV *argvCpp =3D KS_ARGV_TO_CPP(argv_c);
+
+	if (!plugin_ctx->second_pass_done) {
+		/* The second pass is not done yet. */
+		secondPass(plugin_ctx);
+		plugin_ctx->second_pass_done =3D true;
+	}
+
+	IsApplicableFunc checkFieldCS =3D [=3D] (kshark_data_container *d,
+					     ssize_t i) {
+		return !(plugin_cobalt_check_switch_inband(d->data[i]->field)) &&
+			d->data[i]->entry->pid =3D=3D pid;
+	};
+
+	IsApplicableFunc checkEntryPid =3D [=3D] (kshark_data_container *d,
+					      ssize_t i) {
+		return plugin_sched_get_pid(d->data[i]->field) =3D=3D pid;
+	};
+
+	eventFieldIntervalPlot(argvCpp,
+			       plugin_ctx->cs_data, checkFieldCS,
+			       plugin_ctx->cs_data, checkEntryPid,
+			       makeLatencyBox<XenomaiSwitchBox>,
+			       {0, 71, 171}, // Cobalt Blue
+			       -1);         // Default size
+}
diff --git a/src/plugins/xenomai_cobalt_switch_events.c b/src/plugins/xenom=
ai_cobalt_switch_events.c
new file mode 100644
index 0000000..7a8317c
--- /dev/null
+++ b/src/plugins/xenomai_cobalt_switch_events.c
@@ -0,0 +1,174 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen <hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    xenomai_cobalt_switch_events.c
+ *  @brief   handle xenomai cobalt switch context event
+ */
+
+// C
+#include <stdlib.h>
+#include <stdio.h>
+
+// trace-cmd
+#include <trace-cmd.h>
+
+// KernelShark
+#include "plugins/xenomai_cobalt_switch_events.h"
+#include "libkshark-tepdata.h"
+
+/** Plugin context instance. */
+
+//! @cond Doxygen_Suppress
+
+#define SWITCH_INBAND_SHIFT	PREV_STATE_SHIFT
+
+#define SWITCH_INBAND_MASK	PREV_STATE_MASK
+
+//! @endcond
+
+static void cobalt_free_context(struct plugin_cobalt_context *plugin_ctx)
+{
+	if (!plugin_ctx)
+		return;
+
+	kshark_free_data_container(plugin_ctx->cs_data);
+}
+
+/* Use the most significant byte to store state marking switch in-band. */
+static void plugin_cobalt_set_switch_inband_state(ks_num_field_t *field,
+					ks_num_field_t inband_state)
+{
+	unsigned long long mask =3D SWITCH_INBAND_MASK << SWITCH_INBAND_SHIFT;
+	*field &=3D ~mask;
+	*field |=3D (inband_state & SWITCH_INBAND_MASK) << SWITCH_INBAND_SHIFT;
+}
+
+/**
+ * @brief Retrieve the state of switch-in-band from the data field stored =
in
+ *        the kshark_data_container object.
+ *
+ * @param field: Input location for the data field.
+ */
+__hidden int plugin_cobalt_check_switch_inband(ks_num_field_t field)
+{
+	unsigned long long mask =3D SWITCH_INBAND_MASK << SWITCH_INBAND_SHIFT;
+
+	return (field & mask) >> SWITCH_INBAND_SHIFT;
+}
+
+/** A general purpose macro is used to define plugin context. */
+KS_DEFINE_PLUGIN_CONTEXT(struct plugin_cobalt_context, cobalt_free_context=
);
+
+static bool plugin_cobalt_init_context(struct kshark_data_stream *stream,
+				      struct plugin_cobalt_context *plugin_ctx)
+{
+	struct tep_event *event;
+
+	if (!kshark_is_tep(stream))
+		return false;
+
+	plugin_ctx->tep =3D kshark_get_tep(stream);
+
+	event =3D tep_find_event_by_name(plugin_ctx->tep,
+					"cobalt_core", "cobalt_switch_context");
+	if (!event)
+		return false;
+
+	plugin_ctx->cobalt_switch_event =3D event;
+	plugin_ctx->cobalt_switch_next_field =3D
+		tep_find_any_field(event, "next_pid");
+
+	plugin_ctx->second_pass_done =3D false;
+
+	plugin_ctx->cs_data =3D kshark_init_data_container();
+	if (!plugin_ctx->cs_data)
+		return false;
+
+	return true;
+}
+
+static void plugin_cobalt_switch_action(struct kshark_data_stream *stream,
+				      void *rec, struct kshark_entry *entry)
+{
+	struct tep_record *record =3D (struct tep_record *) rec;
+	struct plugin_cobalt_context *plugin_ctx;
+	unsigned long long next_pid;
+	ks_num_field_t ks_field =3D 0;
+	int ret;
+
+	plugin_ctx =3D __get_context(stream->stream_id);
+	if (!plugin_ctx)
+		return;
+
+	ret =3D tep_read_number_field(plugin_ctx->cobalt_switch_next_field,
+				    record->data, &next_pid);
+
+	if (ret =3D=3D 0 && next_pid >=3D 0) {
+		plugin_sched_set_pid(&ks_field, entry->pid);
+		if (next_pid =3D=3D 0) {
+			plugin_cobalt_set_switch_inband_state(&ks_field,
+					SWITCH_INBAND_STATE);
+		}
+
+		kshark_data_container_append(plugin_ctx->cs_data,
+				entry, ks_field);
+
+		if (next_pid > 0)
+			entry->pid =3D next_pid;
+	}
+}
+
+/** Load this plugin. */
+int KSHARK_PLOT_PLUGIN_INITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_cobalt_context *plugin_ctx;
+
+	plugin_ctx =3D __init(stream->stream_id);
+	if (!plugin_ctx || !plugin_cobalt_init_context(stream, plugin_ctx)) {
+		__close(stream->stream_id);
+		return 0;
+	}
+
+	if (plugin_ctx->cobalt_switch_event) {
+		kshark_register_event_handler(stream,
+						plugin_ctx->cobalt_switch_event->id,
+						plugin_cobalt_switch_action);
+	}
+
+	kshark_register_draw_handler(stream, plugin_cobalt_draw);
+
+	return 1;
+}
+
+/** Unload this plugin. */
+int KSHARK_PLOT_PLUGIN_DEINITIALIZER(struct kshark_data_stream *stream)
+{
+	struct plugin_cobalt_context *plugin_ctx =3D __get_context(stream->stream=
_id);
+	int ret =3D 0;
+
+	if (plugin_ctx) {
+		if (plugin_ctx->cobalt_switch_event) {
+			kshark_unregister_event_handler(stream,
+							plugin_ctx->cobalt_switch_event->id,
+							plugin_cobalt_switch_action);
+		}
+
+		kshark_unregister_draw_handler(stream, plugin_cobalt_draw);
+
+		ret =3D 1;
+	}
+
+	__close(stream->stream_id);
+
+	return ret;
+}
+
+/** Initialize the control interface of the plugin. */
+void *KSHARK_MENU_PLUGIN_INITIALIZER(void *gui_ptr)
+{
+	return plugin_set_gui_ptr(gui_ptr);
+}
diff --git a/src/plugins/xenomai_cobalt_switch_events.h b/src/plugins/xenom=
ai_cobalt_switch_events.h
new file mode 100644
index 0000000..f7f4593
--- /dev/null
+++ b/src/plugins/xenomai_cobalt_switch_events.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+
+/*
+ * Copyright (C) 2021 Intel Inc, Hongzhan Chen<hongzhan.chen@intel.com>
+ */
+
+/**
+ *  @file    xenomai_cobalt_switch_events.h
+ *  @brief   Plugin for xenomai cobalt switch context event
+ */
+
+#ifndef _KS_PLUGIN_COBALT_SWITCH_H
+#define _KS_PLUGIN_COBALT_SWITCH_H
+
+// KernelShark
+#include "libkshark.h"
+#include "plugins/common_sched.h"
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+/** cobalt_switch_context is trying to switch in-band. */
+#define SWITCH_INBAND_STATE	1
+
+/** Structure representing a plugin-specific context. */
+struct plugin_cobalt_context {
+	/** Page event used to parse the page. */
+	struct tep_handle	*tep;
+
+	/** Pointer to the cobalt_switch_event object. */
+	struct tep_event	*cobalt_switch_event;
+
+	 /** Pointer to the cobalt_switch_next_field format descriptor. */
+	struct tep_format_field *cobalt_switch_next_field;
+
+	/** True if the second pass is already done. */
+	bool	second_pass_done;
+
+	/** Data container for cobalt_switch_context data. */
+	struct kshark_data_container	*cs_data;
+
+};
+
+KS_DECLARE_PLUGIN_CONTEXT_METHODS(struct plugin_cobalt_context)
+
+int plugin_cobalt_check_switch_inband(ks_num_field_t field);
+
+void plugin_cobalt_draw(struct kshark_cpp_argv *argv, int sd, int pid,
+		 int draw_action);
+
+void *plugin_set_gui_ptr(void *gui_ptr);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
--=20
2.17.1

