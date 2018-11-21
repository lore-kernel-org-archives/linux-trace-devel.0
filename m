Return-Path: <SRS0=0JuE=OA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790078.outbound.protection.outlook.com ([40.107.79.78]:23680
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731165AbeKVBu0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Nov 2018 20:50:26 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 09/11] kernel-shark-qt: Remove all system=ftrace events from
 Record dialog
Date: Wed, 21 Nov 2018 15:14:27 +0000
Message-ID: <20181121151356.16901-11-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
In-Reply-To: <20181121151356.16901-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

"ftrace" system events should not be passed as a command line option
to trace-cmd. This patch remove these events from the checkbox tree of
the Record dialog.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsCaptureDialog.cpp |  1 +
 kernel-shark-qt/src/KsWidgetsLib.cpp    | 10 ++++++++++
 kernel-shark-qt/src/KsWidgetsLib.hpp    |  2 ++
 3 files changed, 13 insertions(+)

diff --git a/kernel-shark-qt/src/KsCaptureDialog.cpp b/kernel-shark-qt/src/=
KsCaptureDialog.cpp
index ee1abc3..5d5ca2f 100644
--- a/kernel-shark-qt/src/KsCaptureDialog.cpp
+++ b/kernel-shark-qt/src/KsCaptureDialog.cpp
@@ -81,6 +81,7 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
=20
 	_eventsWidget.setDefault(false);
 	_eventsWidget.setMinimumHeight(25 * FONT_HEIGHT);
+	_eventsWidget.removeSystem("ftrace");
 	_topLayout.addWidget(&_eventsWidget);
=20
 	_pluginsLabel.adjustSize();
diff --git a/kernel-shark-qt/src/KsWidgetsLib.cpp b/kernel-shark-qt/src/KsW=
idgetsLib.cpp
index dd6ab0f..191ea7d 100644
--- a/kernel-shark-qt/src/KsWidgetsLib.cpp
+++ b/kernel-shark-qt/src/KsWidgetsLib.cpp
@@ -706,6 +706,16 @@ KsEventsCheckBoxWidget::KsEventsCheckBoxWidget(struct =
tep_handle *tep,
 	_adjustSize();
 }
=20
+/** Remove a System from the Checkbox tree. */
+void KsEventsCheckBoxWidget::removeSystem(QString name) {
+	QTreeWidgetItem *item =3D
+		_tree.findItems(name, Qt::MatchFixedString, 0)[0];
+
+	int index =3D _tree.indexOfTopLevelItem(item);
+	if (index >=3D 0)
+		_tree.takeTopLevelItem(index);
+}
+
 /**
  * @brief Create KsTasksCheckBoxWidget.
  *
diff --git a/kernel-shark-qt/src/KsWidgetsLib.hpp b/kernel-shark-qt/src/KsW=
idgetsLib.hpp
index 89c196a..c09bcd5 100644
--- a/kernel-shark-qt/src/KsWidgetsLib.hpp
+++ b/kernel-shark-qt/src/KsWidgetsLib.hpp
@@ -332,6 +332,8 @@ struct KsEventsCheckBoxWidget : public KsCheckBoxTreeWi=
dget
=20
 	KsEventsCheckBoxWidget(struct tep_handle *pe,
 			       QWidget *parent =3D nullptr);
+
+	void removeSystem(QString name);
 };
=20
 /**
--=20
2.17.1
