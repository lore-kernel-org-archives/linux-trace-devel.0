Return-Path: <SRS0=XQBu=M4=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:27872
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726778AbeJPXoU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Oct 2018 19:44:20 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH v2 05/23] kernel-shark-qt: Add visualization (graph) model
Date: Tue, 16 Oct 2018 15:53:02 +0000
Message-ID: <20181016155232.5257-6-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
In-Reply-To: <20181016155232.5257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>

This patch defines the class KsGraphModel which provides a model for
visualization of trace data. This class is a wrapper of kshark_trace_histo
and is needed only because we want to use the signals defined in
QAbstractTableModel (a class inherited by KsGraphModel).

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark-qt/src/KsModels.cpp | 153 +++++++++++++++++++++++++++++++
 kernel-shark-qt/src/KsModels.hpp |  66 +++++++++++++
 2 files changed, 219 insertions(+)

diff --git a/kernel-shark-qt/src/KsModels.cpp b/kernel-shark-qt/src/KsModel=
s.cpp
index 095e26b..5eb1646 100644
--- a/kernel-shark-qt/src/KsModels.cpp
+++ b/kernel-shark-qt/src/KsModels.cpp
@@ -330,3 +330,156 @@ size_t KsViewModel::search(int column,
=20
 	return matchList->count();
 }
+
+/** Create a default (empty) KsFilterProxyModel object. */
+KsGraphModel::KsGraphModel(QObject *parent)
+: QAbstractTableModel(parent)
+{
+	ksmodel_init(&_histo);
+}
+
+/** Destroy KsFilterProxyModel object. */
+KsGraphModel::~KsGraphModel()
+{
+	ksmodel_clear(&_histo);
+}
+
+/**
+ * @brief Provide the Visualization model with data. Calculate the current
+ *	  state of the model.
+ *
+ * @param entries: Input location for the trace data.
+ * @param n: Number of bins.
+ */
+void KsGraphModel::fill(kshark_entry **entries, size_t n)
+{
+	if (n =3D=3D 0)
+		return;
+
+	beginResetModel();
+
+	if (_histo.n_bins =3D=3D 0)
+		ksmodel_set_bining(&_histo,
+				   KS_DEFAULT_NBUNS,
+				   entries[0]->ts,
+				   entries[n-1]->ts);
+
+	ksmodel_fill(&_histo, entries, n);
+
+	endResetModel();
+}
+
+/**
+ * @brief Shift the time-window of the model forward. Recalculate the curr=
ent
+ *	  state of the model.
+ *
+ * @param n: Number of bins to shift.
+ */
+void KsGraphModel::shiftForward(size_t n)
+{
+	beginResetModel();
+	ksmodel_shift_forward(&_histo, n);
+	endResetModel();
+}
+
+/**
+ * @brief Shift the time-window of the model backward. Recalculate the cur=
rent
+ *	  state of the model.
+ *
+ * @param n: Number of bins to shift.
+ */
+void KsGraphModel::shiftBackward(size_t n)
+{
+	beginResetModel();
+	ksmodel_shift_backward(&_histo, n);
+	endResetModel();
+}
+
+/**
+ * @brief Move the time-window of the model to a given location. Recalcula=
te
+ *	  the current state of the model.
+ *
+ * @param ts: position in time to be visualized.
+ */
+void KsGraphModel::jumpTo(size_t ts)
+{
+	beginResetModel();
+	ksmodel_jump_to(&_histo, ts);
+	endResetModel();
+}
+
+/**
+ * @brief Extend the time-window of the model. Recalculate the current sta=
te
+ *	  of the model.
+ *
+ * @param r: Scale factor of the zoom-out.
+ * @param mark: Focus point of the zoom-out.
+ */
+void KsGraphModel::zoomOut(double r, int mark)
+{
+	beginResetModel();
+	ksmodel_zoom_out(&_histo, r, mark);
+	endResetModel();
+}
+
+/**
+ * @brief Shrink the time-window of the model. Recalculate the current sta=
te
+ *	  of the model.
+ *
+ * @param r: Scale factor of the zoom-in.
+ * @param mark: Focus point of the zoom-in.
+ */
+void KsGraphModel::zoomIn(double r, int mark)
+{
+	beginResetModel();
+	ksmodel_zoom_in(&_histo, r, mark);
+	endResetModel();
+}
+
+/** Quick zoom out. The entire data-set will be visualized. */
+void KsGraphModel::quickZoomOut()
+{
+	beginResetModel();
+
+	ksmodel_set_bining(&_histo,
+			   _histo.n_bins,
+			   _histo.data[0]->ts,
+			   _histo.data[_histo.data_size - 1]->ts);
+
+	ksmodel_fill(&_histo, _histo.data, _histo.data_size);
+
+	endResetModel();
+}
+
+/**
+ * @brief Quick zoom in to a state of the Visualization model which has th=
e
+ * given bin size. The actual value of the bin size may en up being slight=
ly
+ * different because of the fine tuning performed by the model.
+ *
+ * @param binSize: an approximate value for the new size of the bins.
+ */
+void KsGraphModel::quickZoomIn(uint64_t binSize)
+{
+	double range, r;
+
+	range =3D  _histo.max - _histo.min;
+	r =3D 1 - (binSize * _histo.n_bins) / range;
+	zoomIn(r);
+}
+
+/** Reset the model. */
+void KsGraphModel::reset()
+{
+	beginResetModel();
+	ksmodel_clear(&_histo);
+	endResetModel();
+}
+
+/** Update the model. Use this function if the data has changed. */
+void KsGraphModel::update(KsDataStore *data)
+{
+	beginResetModel();
+	if (data)
+		ksmodel_fill(&_histo, data->rows(), data->size());
+	endResetModel();
+}
diff --git a/kernel-shark-qt/src/KsModels.hpp b/kernel-shark-qt/src/KsModel=
s.hpp
index 8935fd4..00b20b2 100644
--- a/kernel-shark-qt/src/KsModels.hpp
+++ b/kernel-shark-qt/src/KsModels.hpp
@@ -220,4 +220,70 @@ private:
 		     bool notify);
 };
=20
+/**
+ * Class KsGraphModel provides a model for visualization of trace data. Th=
is
+ * class is a wrapper of kshark_trace_histo and is needed only because we =
want
+ * to use the signals defined in QAbstractTableModel.
+ */
+class KsGraphModel : public QAbstractTableModel
+{
+public:
+	explicit KsGraphModel(QObject *parent =3D nullptr);
+
+	virtual ~KsGraphModel();
+
+	/**
+	 * This dummy function is an implementation of the pure
+	 * virtual method of the abstract model class.
+	 */
+	int rowCount(const QModelIndex &) const override
+	{
+		return _histo.n_bins;
+	}
+
+	/**
+	 * This dummy function is an implementation of the pure
+	 * virtual method of the abstract model class.
+	 */
+	int columnCount(const QModelIndex &) const override {return 0;}
+
+	/**
+	 * This dummy function is an implementation of the pure
+	 * virtual method of the abstract model class.
+	 */
+	QVariant data(const QModelIndex &index, int role) const override
+	{
+		return {};
+	}
+
+	/** Get the kshark_trace_histo object. */
+	kshark_trace_histo *histo() {return &_histo;}
+
+	void fill(kshark_entry **entries, size_t n);
+
+	void shiftForward(size_t n);
+
+	void shiftBackward(size_t n);
+
+	void jumpTo(size_t ts);
+
+	void zoomOut(double r, int mark =3D -1);
+
+	void zoomIn(double r, int mark =3D -1);
+
+	void quickZoomOut();
+
+	void quickZoomIn(uint64_t binSize);
+
+	void reset();
+
+	void update(KsDataStore *data =3D nullptr);
+
+private:
+	kshark_trace_histo	_histo;
+};
+
+/** Defines a default number of bins to be used by the visualization model=
. */
+#define KS_DEFAULT_NBUNS	1024
+
 #endif // _KS_MODELS_H
--=20
2.17.1
